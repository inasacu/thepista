# # to run:    sudo rake the_la_maso
# 
# require 'open-uri'
# require 'nokogiri'                                                                                                                                                                                                                                                                                                                                                                                                                                                             
# 
# desc "Fetch Market from munimadrid.es"
# task :the_la_maso => :environment do|t|
# 
#   # http://www.paginasamarillas.es/centros-deportivos/all-ma/all-pr/all-is/all-ci/all-ba/all-pu/all-nc/120
#   # http://www.google.es/#hl=es&cp=23&gs_id=4&xhr=t&q=centro+deportivo+espana&pf=p&sclient=psy&site=&source=hp&pbx=1&oq=centro+deportivo+espana&aq=f&aqi=&aql=&gs_sm=&gs_upl=&bav=on.2,or.r_gc.r_pw.&fp=36ce908d75f29503&biw=1440&bih=734
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
#   search_and_replace = ['Descripción']
# 
#   centers_url.each do |url|
#     doc = Nokogiri::HTML(open(url))
# 
#     doc.css(".panel5").each do |center|
#             
#       # parrafoTitulo = center.at_css(".parrafoTitulo").text unless doc.at_css(".parrafoTitulo").nil?
#       # listadoInfo = center.at_css(".listadoInfo").text unless doc.at_css(".listadoInfo").nil?
#       parrafo = center.at_css(".parrafo").text unless doc.at_css(".parrafo").nil?
# 
#       # puts "&&& #{parrafoTitulo} &&&"
#       # puts "+++ #{listadoInfo} +++"
#       # puts "@@@ #{parrafo} @@@"
#       
#       # puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#       
#       name = doc.at_css("h3.parrafoTitulo").text unless doc.at_css("h3.parrafoTitulo").nil?
#       latitude = doc.at_css("span.latitude").text unless doc.at_css("span.latitude").nil?
#       longitude = doc.at_css("span.longitude").text unless doc.at_css("span.latitude").nil?
#       phone = doc.at_css("li+li span.value").text unless doc.at_css("li+li span.value").nil?
#      
#       search_and_replace.each {|the_word| parrafo = parrafo.gsub(the_word, ' ')}
# 
#  
#       # values not used due to geocoder
#       # street = doc.at_css("span.street-address").text unless doc.at_css("span.street-address").nil?
#       # zip = doc.at_css("span.postal-code").text unless doc.at_css("span.postal-code").nil?
#       # locality = doc.at_css("span.locality").text unless doc.at_css("span.locality").nil?
#            
#       # parrafoTitulo = doc.at_css(".parrafoTitulo").text unless doc.at_css("parrafoTitulo").nil?
#       # listadoInfo = doc.at_css(".listadoInfo").text unless doc.at_css("listadoInfo").nil?
#       # parrafo = doc.at_css(".parrafo").text unless doc.at_css("parrafo").nil?
#       
#       # parrafoTitulo = doc.at_css("h3.parrafoTitulo").text unless doc.at_css("h3.parrafoTitulo").nil?
#        
#       # location = doc.at_css("h4.dLocalizacion").text.gsub('Localización', '***').gsub('  ', '^') unless doc.at_css("h4.dLocalizacion").nil?
#       # extended_address = doc.at_css("span.extended-address").text.gsub('  ', '^') unless doc.at_css("span.extended-address").nil?
#       # contact = doc.at_css("h4.dContacto").text.gsub('Contacto', '***') unless doc.at_css("h4.dContacto").nil?
# 
#       puts "+++++++++++++++++ GEOCODER INFORMATION ++++++++++++++++++++++++++++++++++++++++"
#       @location = GoogleGeocoder.reverse_geocode([latitude, longitude])  
# 
#       puts  "#{name}"
#       puts  "LAT/LNG:  #{latitude}, #{longitude}"
#       puts  "#{@location.street_address}"
#       puts  "#{@location.city}"
#       puts  "#{@location.state}"
#       puts  "#{@location.zip}"
#       puts  "#{phone}"
# 
#       # puts "++++++++++++++ NOKOGIRI  +++++++++++++++++++++++++++++++++++++++++++"
#       # 
#       # # dont need this right now see example
#       # puts "#{listadoInfo}"   
#       # # Instalación accesible
#       # # 
#       # # 
#       # # Horario
#       # # Consultar con la propia instalación. De lunes a viernes de 9 a 21,30 horas. Sábados, domingos y festivos de 9 a 14 horas.
#       # # 
#       # # Transporte más próximo
#       # # Bus: 59, 79Renfe: San CristóbalMetro: San Cristóbal
#       # # 
#       # # Naturaleza Centro
#       # # Público * Ayuntamiento de Madrid * Distrito de Villaverde
#       
#       
#       puts "++++++++++++++  INFORMATION +++++++++++++++++++++++++++++++++++++++++++"
#       
#       puts "#{parrafo}"   
# 
#       puts  "****************************************************************************"
# 
# 
#       # name, latitude, longitude, lat, lng, phone, address, city, region, zip, description
#       # the_marker = Marker.find(:all, :conditions => ["lat = ? and lng = ?", latitude, longitude])
#       # 
#       #   if the_marker.nil?
#       #     # create new marker
#       #     puts "create new marker"
#       #     
#       #     # Marker.create(:name, latitude, longitude, lat, lng, phone, address, city, region, zip, description)
#       #   else
#       #     # update marker
#       #     puts "update marker"
#       #   end
# 
#     end
#   end
# end
# 
# 
