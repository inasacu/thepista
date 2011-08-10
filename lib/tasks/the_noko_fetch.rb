# to run:    sudo rake the_noko_fetch

require 'nokogiri'
require 'open-uri'

desc "Fetch Market from munimadrid.es"
task :the_noko_fetch => :environment do|t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  
  original_url = "http://www.munimadrid.es"
  
  array_url = [
    "http://www.munimadrid.es/portal/site/munimadrid/menuitem.9d9e646a0a81b0aa7d245f019fc08a0c/?vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD",
    "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=20",
    "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=40",
    "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=60"
  ]
  centers_url = []
  
  
  array_url.each do |url|
    doc = Nokogiri::HTML(open(url))
    doc.css(".enlace").each do |center|
      name = center.at_css(".enlaceGenerico").text
      centers_url << "#{original_url}#{center.at_css(".enlaceGenerico")[:href]}"
      puts name
    end
  end
  
  
  # another
  centers_url.each do |url|
    doc = Nokogiri::HTML(open(url))
  
    doc.css(".panel5").each do |center|
      name = center.at_css(".parrafoTitulo").text
      info = center.at_css(".listadoInfo").text
      parrafo = center.at_css(".parrafo").text
  
      puts name
      puts info
      puts parrafo
      
      
      puts doc.at_css("h3.parrafoTitulo").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li>strong:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li>p:nth-of-type(1)").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(2)>strong:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(2)>p:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(2)>p:nth-of-type(2)").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(3)>strong:nth-of-type(1)").text
      # puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(3):nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(3)").text

      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(2)>ul>li:nth-of-type(4)>strong:nth-of-type(1)").text
      puts doc.at_css("div.listadoInfo span").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul>li:nth-of-type(2)>strong:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul>li:nth-of-type(2)").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul>li:nth-of-type(1)").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul>li:nth-of-type(3)").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>p:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul:nth-of-type(2)>li:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul:nth-of-type(2)>li:nth-of-type(2)").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>p:nth-of-type(2)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul:nth-of-type(3)>li:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul:nth-of-type(3)>li:nth-of-type(2)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul:nth-of-type(3)>li:nth-of-type(3)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div>div:nth-of-type(2)>div:nth-of-type(3)>ul:nth-of-type(3)>li:nth-of-type(4)").text
      puts
      puts doc.at_css("h4.dContacto").text

      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div>div>ul>li:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div>div>ul>li>strong:nth-of-type(1)").text

      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div>div>ul>li>span>span:nth-of-type(2)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div>div>ul>li>span:nth-of-type(1)").text

      puts doc.at_css("li+li span.value").text
      # puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div>div>ul>li>strong:nth-of-type(2)").text
      # puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div>div>ul>li:nth-of-type(2)").text

      puts

      puts doc.at_css("h4.dLocalizacion").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div:nth-of-type(2)>div>ul>li>strong:nth-of-type(1)").text
      puts doc.at_css("span.street-address").text
      puts doc.at_css("span.postal-code").text
      puts doc.at_css("span.locality").text
      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div:nth-of-type(2)>div>ul>li:nth-of-type(2)>strong:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div:nth-of-type(2)>div>ul>li:nth-of-type(2)>span:nth-of-type(1)").text

      puts
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div:nth-of-type(2)>div>ul>li:nth-of-type(3)>strong:nth-of-type(1)").text
      puts doc.at_css("html>body>div>div>div:nth-of-type(4)>div>div>div:nth-of-type(2)>div:nth-of-type(2)>div:nth-of-type(2)>div>ul>li:nth-of-type(3)>span:nth-of-type(1)").text
      puts 
      puts "latitude and longitude"
      puts doc.at_css("span.latitude").text
      puts doc.at_css("span.longitude").text
      
           
      
      
      
      
      
      
      
      
      
      
      @marker = Marker.find_by_name(name)
      
      unless @marker.nil?
        puts "#{@marker.name} was found"
      end
      
      
    end
  end
  
  # Product.find_all_by_price(nil).each do |product|
  #   url = "http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=#{CGI.escape(product.name)}&Find.x=0&Find.y=0&Find=Find"
  #   doc = Nokogiri::HTML(open(url))
  #   price = doc.at_css(".PriceCompare .BodyS, .PriceXLBold").text[/[0-9\.]+/]
  #   product.update_attribute(:price, price)
  # end
end






SYNOPSIS:

require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

doc = Nokogiri::HTML(open('http://www.google.com/search?q=tenderlove'))

# Do funky things with it using Nokogiri::XML::Node methods...

####
# Search for nodes by css
doc.css('h3.r a.l').each do |link|
  puts link.content
end

####
# Search for nodes by xpath
doc.xpath('//h3/a[@class="l"]').each do |link|
  puts link.content
end

####
# Or mix and match.
doc.search('h3.r a.l', '//h3/a[@class="l"]').each do |link|
  puts link.content
end




# $ sudo port install libxml2 libxslt
# $ sudo gem install nokogiri


# Parsing HTML documents looks like this:
# doc = Nokogiri::HTML(html_document)

# Parsing XML documents looks like this:
# doc = Nokogiri::XML(xml_document)

# doc = Nokogiri::HTML(open("http://www.google.com/search?q=doughnuts"))



# ________________________________________________________________________________________________________________________
require 'rubygems'
require 'open-uri'
require 'nokogiri' #using the latest 1.4.0


urls = []
urls << "http://www.google.co.uk/search?q=centros+deportivos+en+madrid&hl=es&prmd=ivnscm&source=univ&tbm=plcs&tbo=u&ei=KAFBTsTmPMOp8AOPqOjiCQ&sa=X&oi=local_group&ct=more-results&resnum=1&ved=0CDIQtQMwAA"
urls << "http://www.madrid.es/portal/site/munimadrid/menuitem.9d9e646a0a81b0aa7d245f019fc08a0c/?vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD"
urls << "http://deportes-entretenimiento.paginas-amarillas.es/centros-deportivos/madrid/20445/28"
urls << "http://www.paginasamarillas.es/centros-deportivos/all-ma/madrid/all-is/all-ci/all-ba/all-pu/all-nc/1"


urls.each do |url|
	doc = Nokogiri::HTML(open(url))

	doc = Nokogiri::HTML(open("http://www.google.com/search?q=doughnuts"))
	doc.xpath('//h3/a').each do |node|
		puts node.text
	end
end








# google search centros deportivos en madrid
# http://www.google.co.uk/search?sourceid=chrome&ie=UTF-8&q=centros+deportivos+en+madrid

# review
# http://www.espormadrid.es/2009/01/centros-deportivos-municipales-de.html

