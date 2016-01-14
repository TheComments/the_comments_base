module TheCommentsBase
  module CommentStates
    extend ActiveSupport::Concern

    COMMENT_STATES = %w[ draft published deleted ]

    included do
      scope :with_state, ->(states) { where state: Array.wrap(states) }
      scope :draft,      ->{ with_state :draft     }
      scope :published,  ->{ with_state :published }
      scope :deleted,    ->{ with_state :deleted   }

      validates_inclusion_of :state, in: COMMENT_STATES

      before_validation ->{
        self.state = 'draft' if self.state.blank?
      }

      before_save ->{
        @state_change = state_change if state_changed?
      }

      after_save :process_state_changes!

      COMMENT_STATES.each do |_state_|
        define_method "#{ _state_ }?" do
          self.state.to_s == _state_.to_s
        end

        define_method "#{ _state_ }!" do
          self.send("state=", _state_)
          save!
        end

        define_method "to_#{ _state_ }" do
          self.send("state=", _state_)
          save!
        end
      end # STATES.each

      def process_state_changes!
        return false if @state_change.blank?
        state_changes = @state_change
        define_common_aasm_variables

        @from = @state_change.first
        @to   = @state_change.last

        # basic life cicle
        letter = case state_changes
          when ['draft', 'published']
            move_from_any_to_draft_or_published
          when ['draft', 'deleted']
            move_from_draft_or_published_to_deleted
          when ['published', 'draft']
            move_from_any_to_draft_or_published
          when ['published', 'deleted']
            move_from_draft_or_published_to_deleted
          when ['deleted', 'draft']
            move_from_any_to_draft_or_published
          when ['deleted', 'published']
            move_from_any_to_draft_or_published
        end

        true
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

# ???

# def update_the_comments_counters
#   define_common_aasm_variables

#   # between delete, draft and published
#   if %i[ draft published deleted ].include?(@from) && %i[ draft published ].include?(@to)
#     move_from_any_to_draft_or_published
#   end

#   # to deleted (cascade like query)
#   if %i[ draft published ].include?(@from) && @to == :deleted
#     move_from_draft_or_published_to_deleted
#   end
# end
