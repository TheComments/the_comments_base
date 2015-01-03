module TheCommentsBase
  def self.configure(&block)
    yield @config ||= TheCommentsBase::Configuration.new
  end

  def self.config
    @config
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :max_reply_depth,
                    :tolerance_time,
                    :default_state,
                    :default_owner_state,
                    :empty_inputs,
                    :default_title,
                    :template_engine,
                    :empty_trap_protection,
                    :tolerance_time_protection,
                    :yandex_cleanweb_api_key,
                    :akismet_api_key,
                    :akismet_blog,
                    :default_mailer_email,
                    :async_processing
  end

  configure do |config|
    config.max_reply_depth     = 3
    config.tolerance_time      = 5
    config.default_state       = :draft
    config.default_owner_state = :published
    config.empty_inputs        = [:message]
    config.default_title       = 'Undefined title'
    config.template_engine     = :slim

    config.empty_trap_protection     = true
    config.tolerance_time_protection = true

    # Anti-spam services
    config.yandex_cleanweb_api_key = nil
    config.akismet_api_key         = nil
    config.akismet_blog            = nil

    # etc
    config.default_mailer_email = 'the_comments@the_platform.com'
    config.async_processing     = false
  end
end
