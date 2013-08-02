Payperdate::Application.configure do
  config.action_mailer.default_url_options = { host: Settings.host }
end

ActionMailer::Base.delivery_method = Settings.mailer.delivery_method

if Settings.mailer.delivery_method == :smtp
  ActionMailer::Base.smtp_settings = Settings.mailer.smtp_settings
end

ENV["MANDRILL_APIKEY"] = Settings.mandrill.api_key
