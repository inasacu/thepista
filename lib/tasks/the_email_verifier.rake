

# https://github.com/kamilc/email_verifier

# gem 'email_verifier'
# gem 'email_veracity'

# require 'email_verifier'
# require 'email_veracity'

# to run:    heroku run rake the_email_verifier --app zurb

desc "task to verify all email accounts"
task :the_email_verifier => :environment do |t|

	EmailVerifier.config do |config|
		config.verifier_email = "the.review.revision@realdomain.com"
	end

	# extensions_to_verify = ['info', 'administracion', 'store','shop','imprensa','contact','office','customer','post','customerservice','mail','lounge','service',
	# 														'staff','sales','press','prensa','welcome','customer.services','enquiry','consulta','web','online','postmaster','admin',	'sport','deporte',
	# 														'deportivo','padel','tenis','golf','contacto','web','online','contactus','help','ayuda','press','prensa','amministrazione',
	# 														'feedback','infomi','you','shop','tienda','store','retail','ventas','main','zone','zona','logistica ','administracion','administration','pedidos','office',
	# 														'oficina','ventas','secretaria','secretary','shopmaster','main','cliente','client','customer','agent','agente']

	extensions_to_verify = ['info']
	# domains = []
	# # extensions = []
	#     
	# # validate email sintax
	#     prospects = Prospect.find(:all, :conditions => "email != '' and archive = false")
	#     prospects.each do |prospect|
	#     
	# 		the_email = prospect.email
	#         the_email_address = EmailVeracity::Address.new(the_email)
	#         
	#         if the_email_address.valid?
	# 	
	#          # puts the_email_address.domain.to_s   
	# 				the_domain = the_email_address.domain.to_s
	#   			domains << the_domain unless domains.include?(the_domain)
	# 				extension = the_email.gsub(the_domain, '').gsub("@","")
	# 				extensions_to_verify << extension unless extensions_to_verify.include?(extension)
	#  
	#         else
	# 	
	#             prospect.notes = 'invalid email'
	# 				prospect.archive = true
	#             prospect.save
	# 				puts "invalid email addres:        *** #{the_email} ***"
	# 				
	#         end
	#     end
	# 
	#  		domains.each do |domain|
	# 	puts domain
	# end
	# 
	# extensions.each do |extension|
	# 	puts extension
	# end

	prospects = Prospect.find(:all, :conditions => "archive = false", :order => "id")
	puts prospects.count
	counter = 0
	prospects.each do |prospect|
		
		puts "#{counter +=1} - #{Time.zone.now}"
		is_verified_email = false
		the_email_address = prospect.email

		# if email is not verified then enter loop to replace with extensions
		is_verified_email = verify_email_address(the_email_address)
		if is_verified_email

			puts "verified.................."
			puts "#{prospect.id}: #{prospect.email }"
			
			# prospect.notes = 'verified'
			# prospect.save

		else
		
			# try adding extensions
			extensions_to_verify.each do |extension|
				unless is_verified_email
		
					the_email_address = "#{extension}@#{the_email_address.split("@").last}" 
					is_verified_email = verify_email_address(the_email_address)
		
				end
			end
		
			# try one last time w/ site name as extension
			unless is_verified_email
		
				the_email_address = "#{the_email_address.split(".").first}@#{the_email_address.split("@").last}" 
				is_verified_email = verify_email_address(the_email_address)
		
			end

		end

		# puts "email address verified.................."
		# puts "id:#{prospect.id} #{prospect.email }, new: #{the_email_address}" 

		# prospect.email = the_email_address if prospect.email != the_email_address
		# prospect.notes = 'verified'
	end


end

def verify_email_address(the_email)

	puts "verify_email_address(#{the_email})"
	is_verified_email = false

	begin  
		is_verified_email = EmailVerifier.check(the_email)
	rescue # StandardError
	rescue Exception
		# handle everything else
	end		

	return is_verified_email

end


