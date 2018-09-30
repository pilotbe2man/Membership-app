require 'mailin.rb'
class RegistrationMailer < ApplicationMailer
    default template_path: 'mailers/registration'
    
    def registration_confirmation (user, template)
        @user = user
        # confirm_url = "http://#{t('mailers.supermanager.url')}/confirm_email/#{@user.confirm_token}"
	    m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
		data = { "personalizations" => [{"to" => [{"email" => @user.email, "name" => "Daycare"}]}],
			"from" => {"email" => t('mailers.supermanager.email'), "name" => t('mailers.supermanager.name') },
			"subject" => t('mailers.mail_confirm.subject'),
			"content" => [{"type" => "text/html", "value" => template}]
		}	 
		result = m.send_email(data)
        puts result
    end

    def send_confirmation user
        @user = user
        mail(to: @user.email, 
            subject: 'Confirm Your Account'
        )
    end

    def reset_password_confirmation (user, template)
        @user = user
        m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
        data = { 
            "personalizations" => [{"to" => [{"email" => @user.email, "name" => "Daycare"}]}],
            "from" => {"email" => t('mailers.supermanager.email'), "name" => t('mailers.supermanager.name') },
            "subject" => t('mailers.mail_reset_password.subject'),
            "content" => [{"type" => "text/html", "value" => template}]
        }    
        result = m.send_email(data)
        puts result
    end

    def register_email_campaign (user, subject, content)
        @user = user
        m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
        data = { "personalizations" => [{"to" => [{"email" => @user.email, "name" => "Daycare"}]}],
            "from" => {"email" => t('mailers.supermanager.email'), "name" => t('mailers.supermanager.name') },
            "subject" => subject,
            "content" => [{"type" => "text/html", "value" => content}]
        }    
        result = m.send_email(data)
    end

    def contact_us_message(user, subject, content)
        m = Mailin.new(ENV['SENDGRID_URL'], ENV['SENDGRID_API_KEY'])
        data = { "personalizations" => [{"to" => [{"email" => t('mailers.supermanager.email'), "name" => "App Manager"}]}],
            "from" => {"email" => user, "name" => 'User' },
            "from" => [user, 'User'],
            "subject" => subject,
            "content" => [{"type" => "text/html", "value" => content}]
        }    
        result = m.send_email(data)
    end
end
