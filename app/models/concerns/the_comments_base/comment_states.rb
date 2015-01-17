module TheCommentsBase
  module CommentStates
    extend ActiveSupport::Concern

    class_methods do
      COMMENT_STATES = %i[ draft published deleted ]
    end

    included do
      include ::AASM

      scope :with_state, ->(states) { where state: Array.wrap(states) }

      aasm column: :state, whiny_transitions: true do
        # state :draft,     initial: true
        # state :published, initial: false
        # state :deleted,   initial: false
        ::Comment::COMMENT_STATES.each do |_state|
          state _state, initial: _state == TheCommentsBase.config.default_state.to_sym
        end

        # event: to_draft
        # event: to_published
        # event: to_deleted
        ::Comment::COMMENT_STATES.each do |_state|
          event "to_#{ _state }", after_commit: :update_the_comments_counters do
            before do
              @from = state.to_sym
              @from = TheCommentsBase.config.default_state.to_sym if @from.blank?
            end

            after do
              @to = state.to_sym
            end

            transitions \
              from: ::Comment::COMMENT_STATES - [_state],
              to: _state
          end
        end
      end

      def update_the_comments_counters
        define_common_aasm_variables

        # between delete, draft and published
        if %i[ draft published deleted ].include?(@from) && %i[ draft published ].include?(@to)
          move_from_any_to_draft_or_published
        end

        # to deleted (cascade like query)
        if %i[ draft published ].include?(@from) && @to == :deleted
          move_from_draft_or_published_to_deleted
        end
      end

      def define_common_aasm_variables
        @comment     = self
        @owner       = @comment.user
        @holder      = @comment.holder
        @commentable = @comment.commentable
      end

      def move_from_any_to_draft_or_published
        if @from.to_s == 'deleted'
          @comment.mark_as_ham
          @owner.try :recalculate_my_comments_counter!
        end

        if @holder
          @holder.update_columns({
            "#{ @to }_comcoms_count"   => @holder.send("#{ @to }_comcoms_count")   + 1,
            "#{ @from }_comcoms_count" => @holder.send("#{ @from }_comcoms_count") - 1
          })
        end

        if @commentable
          @commentable.update_columns({
            "#{ @to }_comments_count"   => @commentable.send("#{ @to }_comments_count")   + 1,
            "#{ @from }_comments_count" => @commentable.send("#{ @from }_comments_count") - 1
          })
        end
      end

      def move_from_draft_or_published_to_deleted
        ids = @comment.self_and_descendants.map(&:id)
        ::Comment.where(id: ids).update_all(state: :deleted)

        @owner.try       :recalculate_my_comments_counter!
        @holder.try      :recalculate_comcoms_counters!
        @commentable.try :recalculate_comments_counters!
      end

    end
  end
end

# included do
#   # STATES: :draft | :published | :deleted

#   # StateMachine - known issue
#   # `initial` param doesn't work
#   # `initial: TheCommentsBase.config.default_state`
#   # solved with `before_save` method and blank value in migration

#   before_save do
#     self.state = TheCommentsBase.config.default_state if self.state.blank?
#   end

#   state_machine :state do
#     # events
#     event :to_draft do
#       transition all - :draft => :draft
#     end

#     event :to_published do
#       transition all - :published => :published
#     end

#     event :to_deleted do
#       transition any - :deleted => :deleted
#     end

#     # transition callbacks
#     after_transition any => any do |comment|
#       @comment     = comment
#       @owner       = comment.user
#       @holder      = comment.holder
#       @commentable = comment.commentable
#     end

#     # between delete, draft and published
#     after_transition [ :deleted, :draft, :published ] => [ :draft, :published ] do |comment, transition|
#       from = transition.from_name
#       to   = transition.to_name

#       if from.to_s == 'deleted'
#         comment.mark_as_ham
#         @owner.try :recalculate_my_comments_counter!
#       end

#       if @holder
#         @holder.update_columns({
#           "#{ to }_comcoms_count"   => @holder.send("#{ to }_comcoms_count")   + 1,
#           "#{ from }_comcoms_count" => @holder.send("#{ from }_comcoms_count") - 1
#         })
#       end

#       if @commentable
#         @commentable.update_columns({
#           "#{ to }_comments_count"   => @commentable.send("#{ to }_comments_count")   + 1,
#           "#{ from }_comments_count" => @commentable.send("#{ from }_comments_count") - 1
#         })
#       end
#     end

#     # to deleted (cascade like query)
#     after_transition [ :draft, :published ] => :deleted do |comment|
#       ids = comment.self_and_descendants.map(&:id)
#       ::Comment.where(id: ids).update_all(state: :deleted)

#       @owner.try       :recalculate_my_comments_counter!
#       @holder.try      :recalculate_comcoms_counters!
#       @commentable.try :recalculate_comments_counters!
#     end
#   end
# end
