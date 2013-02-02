# # to run:    rake the_community_madrid
# 
# 
# require 'open-uri'
# require 'nokogiri'                                                                                                                                                                                                                                                                                                                                                                                                                                                             
# 
# desc "Fetch Market from munimadrid.es"
# task :the_community_madrid => :environment do|t|
# 
#   include GeoKit::Geocoders
# 
#   original_url = "http://www.munimadrid.es"
# 
#   array_url = [
#     "http://www.munimadrid.es/portal/site/munimadrid/menuitem.9d9e646a0a81b0aa7d245f019fc08a0c/?vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD",
#     "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=20",
#     "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=40",
#     "http://www.munimadrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Deportes/Centros-deportivos-municipales?vgnextfmt=default&vgnextoid=c6d8ce52d2e02110VgnVCM1000000b205a0aRCRD&vgnextchannel=cb1a171c30036010VgnVCM100000dc0ca8c0RCRD&iniIndex=60"
#   ]
# 
#   centers_url = []
# 
#   array_url.each do |url|
#     doc = Nokogiri::HTML(open(url))
#     doc.css(".enlace").each do |center|
#       name = center.at_css(".enlaceGenerico").text
#       centers_url << "#{original_url}#{center.at_css(".enlaceGenerico")[:href]}"
#       puts name
#     end
#   end
# 
#   search_and_replace = ['Codigo de instalacion', 'Codigo instalacion', '9999']
# 
#   search_and_add_br = ['EQUIPAMIENTOS', 'Unidades Deportivas al aire libre', 'Unidades Deportivas Cubiertas', 'SERVICIOS',
#                        'Deportes Practicables', 'Alquiler y/o uso libre de Unidades Deportivas', 'Enseñanzas Deportivas', 'Oficina de promocion deportiva',
#                        'Descripcion', 'Forma de gestion', 'Forma de Gestion', 'Directa, por parte del Ayuntamiento de Madrid']
# 
#   search_and_add_space = ['Superficie']
#   
#   centers_url.each do |url|
#     doc = Nokogiri::HTML(open(url))
# 
#     doc.css(".panel5").each do |center|
#             
#       description = center.at_css(".parrafo").text unless center.at_css(".parrafo").nil?
#       name = doc.at_css("h3.parrafoTitulo").text unless doc.at_css("h3.parrafoTitulo").nil?
#       latitude = doc.at_css("span.latitude").text unless doc.at_css("span.latitude").nil?
#       longitude = doc.at_css("span.longitude").text unless doc.at_css("span.latitude").nil?
#       phone = doc.at_css("li+li span.value").text unless doc.at_css("li+li span.value").nil?
#      
#       search_and_replace.each do |the_word| 
#         description = description.gsub(the_word, ' ') unless description.nil?
#       end
#       
#       search_and_add_br.each  do |the_word| 
#         description = description.gsub(the_word, "<br/>#{the_word}<br/>") unless description.nil?
#       end
#       
#       name = name.gsub('Municipal', '').gsub('  ', ' ')
#       
#       @location = GoogleGeocoder.reverse_geocode([latitude, longitude])
#       
#       puts "+++++++++++++++++ GEOCODER INFORMATION ++++++++++++++++++++++++++++++++++++++++"
# 
#       puts  "#{name}"
#       puts  "LAT/LNG:  #{latitude}, #{longitude}"
#       puts  "#{@location.street_address}"
#       puts  "#{@location.city}"
#       puts  "#{@location.state}"
#       puts  "#{@location.zip}"
#       puts  "#{phone}"
#       # puts  "#{description}"
#     
#       puts "**************** create marker *****************************************************"
#       
#       # Marker.create(:name => name, :latitude => latitude, :longitude => longitude, :lat => latitude, :lng => longitude, 
#       #                  :phone => phone, :address => @location.street_address, :city => @location.city, :region => @location.state, :zip => @location.zip, :description => description)
# 
# 
# 			
# 
#       puts  "****************************************************************************"
# 
#     end
#   end
# end
# 
# 
