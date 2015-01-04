class TheCommentsBaseGenerator < Rails::Generators::NamedBase
  source_root TheCommentsBase::Engine.root
  # source_root File.expand_path('../templates', __FILE__)
  # argument :xname, type: :string, default: :xname

  # > rails g the_comments_base OPTION_NAME
  def generate_controllers
    case gen_name
      when 'install'
        # > rails g the_comments_base install
        cp_models
        cp_controllers
        cp_config
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
      when 'all'
        # > rails g the_comments_base all
        cp_models
        cp_controllers
        cp_config
        cp_locales
      else
        puts 'TheComments Generator - wrong Name'
        puts 'Try to use [ install | models | controllers | config | locales | all ]'
    end
  end

  private

  # def root_path; TheCommentsBase::Engine.root; end

  def gen_name
    name.to_s.downcase
  end

  def cp_models
    directory "app/models/_templates_", "app/models"
  end

  def cp_controllers
    directory "app/controllers/_templates_", "app/controllers"
  end

  def cp_config
    d1 = "config/initializers"
    directory d1, d1
  end

  def cp_locales
    d1 = "config/locales"
    directory d1, d1
  end
end
