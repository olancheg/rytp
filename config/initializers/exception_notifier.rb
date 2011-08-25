# Activate ExceptionNotifier gem
Rytp::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[RYTP] ",
  :sender_address => %{"exception notifier" <exceptions@rytp.ru>},
  :exception_recipients => %w{olancheg@gmail.com}
