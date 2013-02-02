# to run:    rake pista_en_juego_com

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

task :pista_en_juego_com => :environment do |t|
	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	main_url = "http://www.pistaenjuego.com"        
	@is_last_url = false
	@current_last_url = ""
	
	@unique_sites = []

	# scraping one unique page
	@pistas = ["http://www.pistaenjuego.com/futbol-7", "http://www.pistaenjuego.com/futbol-sala", "http://www.pistaenjuego.com/futbol-11", "http://www.pistaenjuego.com/tenis",
		"http://www.pistaenjuego.com/padel", "http://www.pistaenjuego.com/squash", "http://www.pistaenjuego.com/fronton", "http://www.pistaenjuego.com/baloncesto",
		"http://www.pistaenjuego.com/balonmano", "http://www.pistaenjuego.com/badminton", "http://www.pistaenjuego.com/voleibol", "http://www.pistaenjuego.com/atletismo",
		"http://www.pistaenjuego.com/rugby", "http://www.pistaenjuego.com/golf", "http://www.pistaenjuego.com/hockey"]

		# @pistas = ["http://www.pistaenjuego.com/futbol-7"]
		@pistas.each {|sub_url| set_pagination_url(sub_url) }


		# while !@is_last_url
		# 	sub_url = @pistas.last
		# 	@is_last_url = (@current_last_url == sub_url)                
		# 	@current_last_url = sub_url
		# 	set_pagination_url(sub_url) unless @is_last_url
		# end
		# 
		# counter = 0
		# @pistas.each do |pista|
		# 	set_parse_each_url(pista)
		# end
		

		@prospects = Prospect.find(:all)
		@prospects.each do |prospect| 
			image, url_additional = get_main_page_information(prospect.url)			
			
			if prospect.image != image
				prospect.image = image
				prospect.save				
				puts "image change:  #{image}"
			end
			
			if prospect.url_additional != url_additional
				prospect.url_additional = url_additional
				prospect.save				
				puts "url_additional change:  #{url_additional}"
			end			
			
		end
			

	end
	
	def get_main_page_information(the_url)
		image = ""
		web = ""
		
		doc = Nokogiri::HTML(open(the_url)) 
		puts "*** #{the_url}"
		
		
		image = doc.css('.main_image img')
		unless image.blank?
			image = image.attribute('src').to_s 
			web = doc.css('.web-icon a')
			web = web && web[0]['href']
		end
		
		return image, web
	end

	def set_parse_each_url(the_url)
		doc = Nokogiri::HTML(open(the_url)) 
		items = doc.css('.center')

		items.each do |item|
			link = item.css('h3 a')
			url = link && link[0]['href'] 

			# prospect table information
			name =  remove_html_information(item.css('h3 a strong'), 'strong')			
			conditions = remove_html_information(item.css('span'), 'span')
			installations =  remove_html_information(item.css('p'), 'p')
			
			# image = items.css('a img')
			# puts "first image #{image}"
			# image = image.attribute('src').to_s
			# puts "second image #{image}"

			@prospect = Prospect.find(:first, :conditions =>["url = ?", url])
			if @prospect.nil? and !url.nil?				
				the_prospect = Prospect.new				
				the_prospect.name =  name
				the_prospect.url = url
				# the_prospect.image =  image
				the_prospect.conditions = conditions
				the_prospect.installations =  installations				
				the_prospect.save
				puts "record saved"
			end


			name =  ""
			url = ""
			# image =  ""
			conditions = ""
			installations =  ""		
		end

	end

	def remove_html_information(the_value, the_remove_value)
		return the_value.to_s.gsub("<#{the_remove_value}>", "").gsub("</#{the_remove_value}>", "") 
	end

	def set_pagination_url(sub_url)
		pagination_x_path = "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'pagination', ' ' ))]//li"
		agent = Mechanize.new
		agent.user_agent_alias = 'Mac Safari'
		page = agent.get(sub_url)
		doc = Nokogiri::HTML(page.body)

		doc.xpath(pagination_x_path).each do |item| 
			the_url = URI.extract(item.to_s)             
			the_url = the_url.to_s.gsub('%255B', '').gsub('%2522', '').gsub('%255D', '').gsub('[', '').gsub(']', '').chop
			the_url[0] = ''
			@pistas << the_url if !@pistas.include?(the_url) and !the_url.blank?   
		end
	end
