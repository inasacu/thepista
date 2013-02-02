# to run:    rake abc_scan_article


require 'anemone'  
require 'open-uri'  
require 'nokogiri'   


task :abc_scan_article => :environment do |t|
	
	url = "http://www.pistaenjuego.com/"
	url = "http://www.chrisumbel.com"


	# crawl this page  
	Anemone.crawl(url) do | anemone |  
	  # only process pages in the article directory  
	  anemone.on_pages_like(/article\/[^?]*$/) do | page |  
	    puts "#{page.url} indexed."  
	  end  
	end



end
