# coding: UTF-8
# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content

# DATA-ATTRIBUTES notice:
#
# data-role (@) for items with handlers or values

module RenderCommentsTreeHelper
  module Render
    class << self
      attr_accessor :h, :options

      # Main Helpers
      def controller
        @options[:controller]
      end

      def t str
        controller.t str
      end

      # Render Helpers
      def visible_draft?
        controller.try(:comments_view_token) == @comment.view_token
      end

      def moderator?
        controller.try(:current_user).try(:admin?) || controller.try(:current_user).try(:comments_moderator?, @comment)
      end

      # Render Methods
      def render_node(h, options)
        @h, @options = h, options
        @comment     = options[:node]

        @max_reply_depth = options[:max_reply_depth] || TheCommentsBase.config.max_reply_depth

        if @comment.draft?
          draft_comment
        else @comment.published?
          published_comment
        end
      end

      def draft_comment
        if visible_draft? || moderator?
          published_comment
        else
          "<li>

            <div data-role='comment' class='comment the_comments--draft p10 mb20 fs14' id='comment_#{ @comment.anchor }'>
              <div class='ptz--table w100p'>
                <div class='ptz--tr'>

                  <div class='ptz--td tal w100p fs15'>
                    #{ t('the_comments.waiting_for_moderation') }
                  </div>

                  <div class='ptz--td pl20 tar fs15'>
                    #{ anchor }
                  </div>
                </div>
              </div>
            </div>

            #{ children }
          </li>"
        end
      end

      def published_comment
        "<li>
          <div data-role='comment' id='comment_#{ @comment.anchor }' class='mb20 comment p10 the_comments--#{ @comment.state }' data-comment-id='#{ @comment.to_param }'>
            #{ moderator_controls }

            <div class='ptz--table w100p mb15'>
              <div class='ptz--tr'>
                <div class='ptz--td vam'>
                  #{ avatar }
                </div>
                <div class='ptz--td pl20 tal w100p fs15'>
                  #{ title }
                </div>
                <div class='ptz--td pl20 tar fs15'>
                  #{ anchor }
                </div>
              </div>
            </div>

            <div class='fs15'>#{ @comment.content }</div>

            <div class='clearfix mt15'>
              <div class='pull-left'>#{ created_at }</div>
              <div class='pull-right fs16'>#{ reply }</div>
            </div>

          </div>

          <div class='the_comments--form_holder' data-role='form_holder'></div>
          #{ children }
        </li>"
      end

      def avatar
        "<img src='#{ @comment.avatar_url }' alt='userpic' class='the_comments--userpic w50' />"
      end

      def anchor
        h.link_to('#', '#comment_' + @comment.anchor)
      end

      def created_at
        date = @comment.created_at
        date = I18n.l(date, format: "%-d %B %Y %H:%M").html_safe
      end

      def title
        if @comment.user
          @comment.user.username
        else
          @comment.title.blank? ? t('the_comments.guest_name') : @comment.title
        end
      end

      def moderator_controls
        if moderator?
          "<div class='controls mb10 p5 fs13 tar the_comments--moderator_controls'>#{
            h.link_to(t('the_comments.edit'), h.edit_comment_url(@comment), class: :edit)
          }</div>"
        end
      end

      def reply
        if @comment.depth < (@max_reply_depth - 1)
          "<div class='the_comments--reply_holder'>
            <a href='#' data-role='reply_link'>
              #{ t('the_comments.reply') }
            </a>
          </div>"
        end
      end

      def children
        "<ol class='pl20 the_comments--nested_set' data-role='nested_set'>#{ options[:children] }</ol>"
      end
    end
  end
end
