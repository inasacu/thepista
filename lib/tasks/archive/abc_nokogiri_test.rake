# # to run:    rake abc_nokogiri_test
# 
# require 'open-uri'
# require 'nokogiri'                                                                                                                                                                                                                                                                                                                                                                                                                                                             
# 
# desc "Fetch Market from munimadrid.es"
# task :abc_nokogiri_test => :environment do|t|
# 
#   # http://www.paginasamarillas.es/centros-deportivos/all-ma/all-pr/all-is/all-ci/all-ba/all-pu/all-nc/120
#   # http://www.google.es/#hl=es&cp=23&gs_id=4&xhr=t&q=centro+deportivo+espana&pf=p&sclient=psy&site=&source=hp&pbx=1&oq=centro+deportivo+espana&aq=f&aqi=&aql=&gs_sm=&gs_upl=&bav=on.2,or.r_gc.r_pw.&fp=36ce908d75f29503&biw=1440&bih=734
# 
#   include GeoKit::Geocoders
# 
#   original_url = "http://www.munimadrid.es"
# 
#   array_url = [
#     # "http://www.munimadrid.es/portal/site/munimadrid/menuitem.9d9e646a0a81b0aa7d245f019fc08a0c/?vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD",
#     "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=20",
#     "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=40",
#     # "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=60"
#   ]
# 
#   centers_url = []
# 
#   array_url.each do |url|
#     doc = Nokogiri::HTML(open(url))
#     doc.css(".enlace").each do |center|
# 
#       name = center.at_css(".enlaceGenerico").text
#       if name == "Centro Deportivo Municipal Luis Aragonés"
#         centers_url << "#{original_url}#{center.at_css(".enlaceGenerico")[:href]}"
# 
#         puts name
#       end
#     end
#   end
# 
#   puts " locations url found ................."
#   puts
# 
#   search_and_replace = ['Descripción', 'Forma de gestión', 'Forma de Gestión', 'Directa, por parte del Ayuntamiento de Madrid']
# 
#   search_and_add_br = ['Tipo de Gestión Superficie', 'EQUIPAMIENTOS', 'Unidades Deportivas al aire libre', 'Unidades Deportivas Cubiertas', 'SERVICIOS',
#     'Deportes Practicables', 'Alquiler y/o uso libre de Unidades Deportivas', 'Enseñanzas Deportivas', 'Oficina de promoción deportiva']
# 
#     centers_url.each do |url|
#       doc = Nokogiri::HTML(open(url))
# 
#       doc.css(".panel5").each do |center|
# 
#         parrafo = center.at_css(".parrafo sg_selected").text  unless center.at_css(".parrafo sg_selected").nil? 
#         name = doc.at_css("h3.parrafoTitulo").text unless doc.at_css("h3.parrafoTitulo").nil?
# 
#         puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #{name}"
#         the_path = center.path
# 
#         puts the_path
# 
#         the_path = the_path.gsub('/html/', 'html>')
#         the_path = the_path.gsub('/', '>')
#         the_path = the_path.gsub('[', ':nth-of-type(')
#         the_path = the_path.gsub(']', ')')
# 
#         puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ the path start ~~~~~~~~~"
#         puts "PATH:   #{the_path}"            
#         # puts doc.at_css(the_path).text  
#         puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ the path end ~~~~~~~~~"
# 
#         puts "begin"
#         doc.xpath('//li').each do |point|
#           puts point.text unless point.nil?          
#         end
#         puts "end"
#         # @links = doc.xpath('//ul/li').map do |i| 
#         #   {'ul' => i.xpath('//ul'), 'li' => i.xpath('//li')}
#         # end
#         # 
#         # # counter = 0
#         # @links.each do |link|
#         #   puts link['ul']
#         #   # puts link.li
#         #   # counter += 1
#         # end 
#         
#       end
#     end
#   end
# 
# 
