# to run:    rake pista_en_juego_com

# review the following sites:
# http://railscasts.com/episodes/190-screen-scraping-with-nokogiri
# http://railscasts.com/episodes/191-mechanize

# 
# require 'rubygems'
# require 'nokogiri'
# require 'open-uri'
# 
# 
# task :pista_en_juego_com => :environment do |t|
# 
# 	original_url = "http://www.pistaenjuego.com"	
# 	url = "http://www.pistaenjuego.com/futbol-7/madrid"
# 
# 	doc = Nokogiri::HTML(open(url))  
# 
# 	# puts doc.at_css("title").text
# 	
# 	the_paginations = doc.css('.pagination')	
# 	counter = 0
# 	
# 	the_paginations.each do |the_pagination|
# 
# 		the_links = the_pagination.doc.css('ul')
# 
# 		the_links.each do |a_link|
# 			link = a_link.css('li')
# 			the_url = link && link[0]['href'] #=> url is nil if no link is found on the page
# 			puts the_url
# 			puts counter +=1
# 		end
# 
# 	end
# 
# 	
# 	
# 	
# 	
# 	the_items = doc.css('.center')
# 	the_items.each do |item|
# 		
# 		# link = item.css('h3 a')
# 		# the_url = link && link[0]['href'] #=> url is nil if no link is found on the page
# 		# puts the_url
# 
# 
# 
# 		#   array_url = []
# 		#   centers_url = []
# 		# 
# 		#   array_url.each do |url|
# 		#     doc = Nokogiri::HTML(open(url))
# 		#     doc.css(".enlace").each do |center|
# 		#       name = center.at_css(".enlaceGenerico").text
# 		#       centers_url << "#{original_url}#{center.at_css(".enlaceGenerico")[:href]}"
# 		#       puts name
# 		#     end
# 		#   end
# 		
# 
# 
# 	end
# 	
# 	
# 	
# end
# 
# 
