# to run:    rake pista_en_juego_orcasitas

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require "uri"

task :pista_en_juego_orcasitas => :environment do |t|
	# scraping one unique page
	# sub_url = "http://www.pistaenjuego.com/centro-deportivo-municipal-orcasitas-p406"
	the_url = 'http://www.pistaenjuego.com/s-magariaga-tenis-club-p234'
  doc = Nokogiri::HTML(open(the_url))
	puts "*** #{the_url}"
	image = doc.css('.main_image img')
	
	image = image.attribute('src').to_s unless image.blank?
	
	puts "[#{image}]"
	
	
end



