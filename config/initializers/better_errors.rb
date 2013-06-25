if Rails.env.staging?
  Payperdate::Application.config.action_dispatch.show_exceptions = true
  Payperdate::Application.config.log_level                       = :debug
end