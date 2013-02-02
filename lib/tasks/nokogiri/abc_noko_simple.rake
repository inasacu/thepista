# to run:    rake abc_noko_simple

require 'nokogiri'   
require 'open-uri'  


task :abc_noko_simple => :environment do |t|


	doc = Nokogiri::HTML(open('http://www.ruby-doc.org/core/classes/Bignum.html'))  

	doc.xpath('//span[@class="method-name"]').each do | method_span |  
		puts method_span.content  
		puts method_span.path  
		puts  
	end


end
