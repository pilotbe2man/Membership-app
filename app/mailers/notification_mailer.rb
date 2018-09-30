require 'mailin.rb'
class NotificationMailer < ApplicationMailer
  default template_path: 'mailers/message_notification'

  def notify notification, sender, content
    @email = notification.target.email
    m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
		data = { 
			"personalizations" => [{"to" => [{"email" => notification.target.email, "name" => notification.target.name}]}],
			"from" => {"email" => sender.email, "name" => sender.name },
			"subject" => "You have a new notification from #{sender.name}",
			"content" => [{"type" => "text/html", "value" => content}]
		}
 
		result = m.send_email(data)
  end

  def notify1 sender, content, email
    m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
		data = { 
			"personalizations" => [{"to" => [{"email" => email}]}],
			"from" => {"email" => sender.email, "name" => sender.name },
			"subject" => "You have a new notification from #{sender.name}",
			"content" => [{"type" => "text/html", "value" => content}]
		}
	 
		result = m.send_email(data)
  end

    def plan_confirmation (user, template, attachment)
        @user = user
	    m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
		data = { 
			"personalizations" => [{"to" => [{"email" => @user.email, "name" => "Daycare"}]}],
			"from" => {"email" => t('mailers.supermanager.email'), "name" => t('mailers.supermanager.name') },
			"subject" => t('mailers.plan_confirm.subject'),
			"content" => [{"type" => "text/html", "value" => template}]
		}
		# data = { "to" => {@user.email => "Daycare"},
		# 	"from" => [t('mailers.supermanager.email'), t('mailers.supermanager.name')],
		# 	"subject" => t('mailers.plan_confirm.subject'),
		# 	"html" => template,
		# 	"attachment" => attachment
		# }	 
		result = m.send_email(data)
    end

end
