# to run:    rake the_email_verification


require 'resolv'

task :the_email_verification => :environment do |t|
	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	counter = 0

	@prospects = Prospect.find(:all, :conditions =>"email is not null and email !=''")

	# clean out and save emails
	# @prospects.each do |prospect|
	# 	prospect.email = prospect.email.strip
	# 	prospect.save
	# 	# puts "[#{prospect.email}]"
	# end
	@all_emails = []

	@prospects.each do |prospect| 
		is_valid_email = validate_email_domain(prospect.email)

		unless @all_emails.include?(prospect.email)
			@all_emails << prospect.email 
			puts "(#{counter+=1}) #{prospect.id}: [#{prospect.email}]" if is_valid_email
		end
	end

end

def validate_email_domain( value )
	begin
		return false if value == ''
		parsed = Mail::Address.new( value )
		return parsed.address == value && parsed.local != parsed.address
	rescue Mail::Field::ParseError
		return false
	end
end