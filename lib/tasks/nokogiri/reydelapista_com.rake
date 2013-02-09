# to run:    rake reydelapista_com

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

task :reydelapista_com => :environment do |t|
	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	# scraping one unique page
	@pistas = []
	the_basic_page =  "http://www.reydelapista.com/clubes.php?club=&_pagi_pg="
	1.times do |count|		
		@pistas << "#{the_basic_page}#{count+1}"
	end

	counter = 0
	@pistas.each do |pista|
		set_parse_each_url(pista)
		# puts pista
	end

end


def set_parse_each_url(the_url)	
	name_x_path ="//*[(@id = 'izq')]//h3"
	agent = Mechanize.new
	agent.user_agent_alias = 'Mac Safari'
	page = agent.get(the_url)
	doc = Nokogiri::HTML(page.body)

	doc.xpath(name_x_path).each do |item|
		puts item
		
		# the_url = URI.extract(item.to_s)             
		# the_url = the_url.to_s.gsub('%255B', '').gsub('%2522', '').gsub('%255D', '').gsub('[', '').gsub(']', '').chop
		# the_url[0] = ''
		# puts the_url  
	end

end

# def remove_html_information(the_value, the_remove_value)
# 	return the_value.to_s.gsub("<#{the_remove_value}>", "").gsub("</#{the_remove_value}>", "") 
# end

