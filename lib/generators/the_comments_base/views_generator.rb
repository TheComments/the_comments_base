module TheCommentsBase
  module Generators
    class ViewsGenerator < Rails::Generators::NamedBase
      source_root TheCommentsBase::Engine.root

      def self.banner
<<-BANNER.chomp

USAGE: [bundle exec] rails g the_comments_base:views OPTION_NAME

> rails g the_comments_base:views js
> rails g the_comments_base:views css
> rails g the_comments_base:views assets

> rails g the_comments_base:views views
> rails g the_comments_base:views helper

> rails g the_comments_base:views all

BANNER
      end

      def copy_sortable_tree_files
        copy_gem_files
      end

      private

      def param_name
        name.downcase
      end

      def copy_gem_files
        case param_name
          when 'js'
            # rails g the_comments_base:views js
            js_copy
          when 'css'
            # rails g the_comments_base:views css
            css_copy
          when 'assets'
            # rails g the_comments_base:views assets
            js_copy; css_copy
          when 'views'
            # rails g the_comments_base:views views
            views_copy
          when 'helper'
            # rails g the_comments_base:views helper
            helper_copy
          when 'all'
            js_copy
            css_copy
            views_copy
            helper_copy
          else
            puts 'TheCommentsBase View Generator - wrong Name'
            puts "Wrong params - use only [ js | css | assets | views | helper | all ] values"
        end
      end

      def js_copy
        d1 = "app/assets/javascripts"
        directory d1, d1
      end

      def css_copy
        d1 = "app/assets/stylesheets"
        directory d1, d1
      end

      def views_copy
        d1 = "app/views/the_comments"
        directory d1, d1
      end

      def helper_copy
        d1 = "app/helpers"
        directory d1, d1
      end
    end
  end
end
