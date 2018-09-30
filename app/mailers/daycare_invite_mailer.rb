require 'mailin.rb'
class DaycareInviteMailer < ApplicationMailer
    default template_path: 'mailers/daycare'

    def invite (email, subject, content, from_email, from_name)
	    m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
	    if email.is_a? Array
			email.each do |email|
				data = {
					"personalizations" => [{"to" => [{"email" => email, "name" => "Daycare"}]}],
					"from" => {"email" => from_email, "name" => from_name },
					"subject" => subject,
					"content" => [{"type" => "text/html", "value" => content}]
				}
				result = m.send_email(data)
			end
		else
			data = {
				"personalizations" => [{"to" => [{"email" => email, "name" => "Daycare"}]}],
				"from" => {"email" => from_email, "name" => from_name },
				"subject" => subject,
				"content" => [{"type" => "text/html", "value" => content}]
			}
			result = m.send_email(data)
		end
    end
end