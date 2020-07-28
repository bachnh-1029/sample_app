class ApplicationMailer < ActionMailer::Base
  default from: ENV["mail_from"]
  layout "mailer"
end
