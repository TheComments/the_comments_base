class TheCommentsBaseGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  # argument :xname, type: :string, default: :xname

  # > rails g the_comments_base NAME
  # example: rails g the_comments_base controllers
  def generate_controllers
    case gen_name
      when 'models'
        # > rails g the_comments_base models
        cp_models
      when 'controllers'
        # > rails g the_comments_base controllers
        cp_controllers
      when 'config'
        # > rails g the_comments_base config
        cp_config
      when 'locales'
        # > rails g the_comments_base locales
        cp_locales
      when 'install'
        # > rails g the_comments_base install
        cp_models
        cp_controllers
        cp_config
        cp_locales
      else
        puts 'TheComments Generator - wrong Name'
        puts 'Try to use [ install | models controllers | config | locales ]'
    end
  end

  private

  def root_path; TheCommentsBase::Engine.root; end

  def gen_name
    name.to_s.downcase
  end

  def cp_models
    _path = "#{ root_path }/app/models/_templates_"

    # comment_subscription.rb
    %w[ comment.rb ].each do |file_name|
      copy_file "#{ _path }/#{ file_name }", "app/models/#{ file_name }"
    end
  end

  def cp_controllers
    # comment_subscriptions_controller.rb
    _path = "#{ root_path }/app/controllers/_templates_"
    %w[ comments_controller.rb ].each do |file_name|
      copy_file "#{ _path }/#{ file_name }", "app/controllers/#{ file_name }"
    end
  end

  def cp_config
    copy_file "#{ root_path }/config/initializers/the_comments_base.rb",
              "config/initializers/the_comments_base.rb"
  end

  def cp_locales
    _path = "#{ root_path }/config/locales"

    %w[ en.the_comments_base.yml ru.the_comments_base.yml ].each do |file_name|
      copy_file "#{ _path }/#{ file_name }", "config/locales/#{ file_name }"
    end
  end
end
