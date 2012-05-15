class UserMailer < ActionMailer::Base
  default from: "support@haypista.com"

	def send_email(user)
	   recipients  user.email
	   from        "support@haypista.com"
	   subject     "Thank you for Registering"
	   part 			 :content_type => "text/html", 
								 :body => render_message("registration_confirmation", 
								 :user => user)
	end
	
end
