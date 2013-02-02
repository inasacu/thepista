# to run:    rake the_mechanize

require 'rubygems'
require 'mechanize'
require 'hpricot'


task :the_mechanize => :environment do |t|
# 	url = "http://www.pistaenjuego.com/futbol-7/madrid"
# 
# 	agent = Mechanize.new
# 	page = agent.get(url)
# 	@response = page.content
# 	doc = Hpricot(@response)
# 	doc.search("//div[@class='center h3']").search("a").innerHTML
# end
# 
# 
# desc "Import wish list"
# task :import_list => :environment do
  # require 'mechanize'
  # agent = Mechanize.new
  # 
  # agent.get("http://railscasts.tadalist.com/session/new")
  # form = agent.page.forms.first
  # form.password = "secret"
  # form.submit
  # 
  # agent.page.link_with(:text => "Wish List").click
  # agent.page.search(".edit_item").each do |item|
  #   put item.text.strip
  # end

	require 'nokogiri'
	require 'mechanize'

	
	url = "http://www.pistaenjuego.com/futbol-7/madrid" # 2, 3, 4
	x_path = "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'pagination', ' ' ))]//li"
	agent = Mechanize.new
	agent.user_agent_alias = 'Mac Safari'
	page = agent.get(url)
	doc = Nokogiri::HTML(page.body)
	doc.xpath(x_path).each { |value| puts value }
	
	
end