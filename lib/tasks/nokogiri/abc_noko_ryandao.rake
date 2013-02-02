# # to run:    rake scrape_test_consecutive
# 
# # http://www.ryandao.net/portal/content/ruby-rails-screen-scraping-nikogiri-and-openuri
# # http://www.pistaenjuego.com/
# 
# 
# require 'open-uri'
# require 'nokogiri'                                                                                                                                                                                                                                                                                                                                                                                                                                                             
# 
# desc "Fetch Market from munimadrid.es"
# task :scrape_test_consecutive => :environment do |t|
# 	require 'open-uri'
# 	require 'nokogiri'
# 	require 'logger'
# 
# 	proxy_username = 'your_proxy_username'
# 	proxy_password = 'your_proxy_password'
# 	proxy_ip = 'your_proxy_ip'
# 	proxy_port = 'your_proxy_port' 
# 	# url = 'scraping_url' 
# 	url = "http://www.pistaenjuego.com"
# 
# 	log = Logger.new("#{Rails.root}/log/scrape_test.log")
# 	log.info "* [#{DateTime.now}] Test scraping url #{url} with proxy #{proxy_ip}:#{proxy_port}"
# 	scraping_start_time = DateTime.now
# 	num_of_query = 0
# 
# 	while true do
# 		num_of_query += 1
# 		begin
# 			query_start_time = DateTime.now
# 			doc = Nokogiri::HTML(open( 
# 			url,
# 			:proxy_http_basic_authentication => ["http://#{proxy_ip}:#{proxy_port}", proxy_username, proxy_password]
# 			))
# 
# 		rescue OpenURI::HTTPError => e
# 			log.error "Query #{num_of_query} failed with error: #{e.message}"
# 			break // if HTML errors occur, stop testing
# 			end
# 
# 			log.info "Query #{num_of_query} executed successfully in #{((DateTime.now - startQueryTime) * 24 * 60 * 60).to_f}"
# 		end
# 
# 		log.info "* [#{DateTime.now}] Finished testing with proxy #{proxy_ip} in #{DateTime.now - scraping_start_time. Total queries: #{num_of_query}"
# 	end