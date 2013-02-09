# to run:    rake clubdeportivos_com

# t.string			:name
# t.string			:contact
# t.string			:email
# t.string			:email_additional
# t.string			:phone
# t.string			:url
# t.string			:url_additional
# t.string			:image
# t.text				:installations
# t.text				:description
# t.text				:conditions
# t.text				:notes
# t.datetime		:letter_first
# t.datetime		:letter_second
# t.datetime		:response_first
# t.datetime		:response_second



require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require "uri"

task :clubdeportivos_com => :environment do |t|
	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	@all_pistas = []


	# "http://www.clubdeportivos.com/busqueda-clubdeportivo.php"
	# "http://www.clubdeportivos.com/busqueda-clubdeportivo.php?club=&_pagi_pg=25"
	final_destination = "http://www.clubdeportivos.com/club-deportivo.php?id=437&amp;clubdeportivo=wellsport%20club"

	# scraping one unique page
	default_page = "http://www.clubdeportivos.com/busqueda-clubdeportivo.php?club=&_pagi_pg="
	@pistas = []

	25.times.each do |counter|
		@pistas << "#{default_page}#{counter+1}"		
	end

	counter = 0
	@pistas.each do |the_url|
		# puts "page #{counter += 1} - #{the_url}"

		pagination_x_path = "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'caja_club', ' ' ))]//ul"
		agent = Mechanize.new
		agent.user_agent_alias = 'Mac Safari'
		page = agent.get(the_url)
		doc = Nokogiri::HTML(page.body)

		doc.xpath(pagination_x_path).each do |item| 			
			# abc = 0
			items = item.css('li em a')
			items.each do |the_item|
				# puts "values #{abc += 1}"
				a_href = the_item.to_s.gsub('href="', 'href="http://www.clubdeportivos.com/')
				the_item_url =  URI.extract(a_href)				
				@all_pistas << the_item_url
			end

		end

	end

	# @all_pistas.each do |a_pista|
	# 	puts a_pista			
	# end

	puts "#######################################################################################"

	actual_site_counter = 0
	@all_pistas.each do |a_pista|

		has_email = false
		is_discard = false
		# puts actual_site_counter += 1

		final_destination = a_pista.to_s.gsub('"', '').gsub('%255B', '').gsub('%2522', '').gsub('%255D', '').gsub('[', '').gsub(']', '').chop
		final_destination = final_destination.strip.gsub(" ", "%20")

		begin
			doc = Nokogiri::HTML(open(final_destination))
		rescue Exception => err
			# puts err
			is_discard = true
		end

		unless is_discard 

			email = ".caja_der_club a:nth-child(3)"
			email = doc.css(email.to_s)
			a_hrefs = URI.extract(email.to_s)
			a_hrefs.each do |a_href|
				if a_href.include?('mailto:')
					email = a_href.to_s.gsub('mailto:','').gsub('%20','')
				end
			end

			phone = ".caja_der_club li:nth-child(2)"
			phone = doc.css(phone.to_s)
			phone = remove_html_span(phone)
			phone = remove_html_information(phone, 'li')
			phone = remove_html_information(phone, 'span')
			phone = phone.gsub('Telefono:','').strip.gsub('<br>','')

			name = "#centro :nth-child(1) h2"	
			name = doc.css(name.to_s)
			name = remove_html_information(name, 'h2')
			name = name.to_s.gsub('?', '').strip

			providence =  ".caja_der_club li:nth-child(4)"
			providence = doc.css(providence.to_s)
			providence = remove_html_information(providence, 'li')
			providence = remove_html_span(providence)
			providence = providence.gsub('Provincia:', '').gsub('<br>','')
			providence = remove_html_information(providence, 'span')
			providence = providence.to_s.gsub('Email:<a href="mailto:', '').gsub('target', ', ').gsub('"', '').gsub('blank', '').gsub('=_>', '')
			providence = remove_html_information(providence, 'a')
			providence = providence.gsub('?', '')


			if email.to_s.length > 254	
				email = ""
			else
				puts actual_site_counter += 1
				has_email = true
			end

			if has_email
				puts "______________________________________________________________________"
				puts final_destination
				puts "name:   #{name}"
				puts "email:  #{email}"
				puts "phone:  #{phone}"
				puts "prov:   #{providence}"
				
					



				@prospect = Prospect.find(:first, :conditions =>["url = ?", final_destination])
				if @prospect.nil? and !final_destination.nil?				
					the_prospect = Prospect.new				
					# the_prospect.name =  email			
					# the_prospect.url =  email
					# the_prospect.notes = final_destination
					the_prospect.phone = phone
					the_prospect.email =  email
					the_prospect.email_additional = providence				
					the_prospect.save
					puts "record saved"				
				end


				puts "______________________________________________________________________"
				puts 

			end
		end



	end

end

def remove_html_span(the_value)
	return the_value.to_s.gsub('<span class="boldnegroclub">','')
end

def remove_html_information(the_value, the_remove_value)
	return the_value.to_s.gsub("<#{the_remove_value}>", "").gsub("</#{the_remove_value}>", "") 
end
