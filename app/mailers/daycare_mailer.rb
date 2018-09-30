require 'mailin.rb'
class DaycareMailer < ApplicationMailer
    default template_path: 'mailers/daycare'

    def invite (email, message)
        @email = email
	    m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
#	    puts email
		data = { 
			"personalizations" => [{"to" => [{"email" => email, "name" => "Daycare"}]}],
			"from" => {"email" => message.owner.email, "name" => message.owner.name },
			"subject" => message.title,
			"content" => [{"type" => "text/html", "value" => message.content}]
		}
	 
		result = m.send_email(data)
	    puts "---DaycareMailer---"
	    puts result
		
#		puts result
#        mail(to: @email, 
#            subject: "You have been invited to start using Health Childcare"
#        )
    end
end