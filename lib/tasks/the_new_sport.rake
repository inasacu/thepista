# to run:    sudo heroku rake the_new_sport --app thepista

desc "  # add new sports to list"
task :the_new_sport => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  [
      ['Balonmano', 'Balonmano, Handball', 'volleyball.png', 1,  0,  0,  12], 
      ['Baseball', 'Beisbol, Baseball', 'baseball.jpg', 1,  0,  0,  16],
      ['Rugby', 'Rugby', 'football.gif',  1,  0,  0,  30],
      ['Bádminton', 'Bádminton', 'volleyball.png',  1,  0,  0,  30],
      ['Escalada', 'Escalada', 'volleyball.png',  1,  0,  0,  10],
      ['Natación', 'Natación', 'volleyball.png',  1,  0,  0,  10],
      ['Musculación', 'Musculación', 'volleyball.png',  1,  0,  0,  10],
      ['Aeróbic', 'Aeróbic', 'volleyball.png',  1,  0,  0,  10] 
      
  ].each do |sport|
    Sport.create(:name => sport[0], :description => sport[1], :icon => sport[2],  
    :points_for_win => sport[3], :points_for_lose => sport[4], :points_for_draw => sport[5], :player_limit => sport[6] )
  
  end
  
  the_sport = Sport.find(:all, :conditions => "name = 'Volleyball'")
  the_sport.each do |sport|
    sport.icon = 'volleyball.png'
    sport.description = sport.name
    sport.player_limit = 12
    sport.save
    puts sport.name
  end
  
  the_sport = Sport.find(:all, :conditions => "name = 'Futbol 7'")
  the_sport.each do |sport|
    sport.description = sport.name
    sport.player_limit = 14
    sport.save
    puts sport.name
  end
  
  the_sport = Sport.find(:all, :conditions => "name = 'Padel'")
  the_sport.each do |sport|
    sport.description = sport.name
    sport.player_limit = 4
    sport.save
    puts sport.name
  end
  
  the_sport = Sport.find(:all, :conditions => "name in ('Futbol 11', 'Football', 'Soccer')")
  the_sport.each do |sport|
    sport.description = sport.name
    sport.player_limit = 22
    sport.save
    puts sport.name
  end
  
  the_sport = Sport.find(:all, :conditions => "name in ('FutSal', 'Basketball', 'Hockey')")
  the_sport.each do |sport|  
    sport.description = sport.name
    sport.player_limit = 10
    sport.save
    puts sport.name
  end
  
  the_sport = Sport.find(:all, :conditions => "name in ('Golf', 'Tennis', 'Other')")
  the_sport.each do |sport|
    sport.description = sport.name
    sport.player_limit = 2
    sport.save
    puts sport.name
  end
  
  
  
  [['Madrid'],['Álava'],['Albacete'],['Alicante'],['Almería'],['Asturias'],['Ávila'],['Badajoz'],['Illes Baleares'],['Barcelona'],['Burgos'],
  ['Cáceres'],['Cádiz'],['Cantabria'],['Castellón'],['Ceuta'],['Ciudad Real'],['Córdoba'],['Cuenca'],['Girona'],['Granada'],['Guadalajara'],['Guipúzcoa'],
  ['Huelva'],['Huesca'],['Jaén'],['Coruña A'],['La Rioja'],['Las Palmas'],['León'],['Lleida'],['Lugo'],['Málaga'],['Melilla'],['Murcia'],['Navarra'],
  ['Ourense'],['Palencia'],['Pontevedra'],['Salamanca'],['Santa Cruz de Tenerife'],['Segovia'],['Sevilla'],['Soria'],['Tarragona'],['Teruel'],
  ['Toledo'],['Valencia'],['Valladolid'],['Vizcaya'],['Zamora'],
  ['Zaragoza']].each do |state|
    State.create(:name => state[0])
  end
  
  
  # add cities w/ coresponding state
   [['Madrid ',1], [' Adra ',5], [' Aguadulce ',5], [' Albacete ',3], [' Alba de Tormes ',40], [' Alberca ',40], [' Albir  ',4], ['Albufeira (La)',48], [' Alcalá de Henares ',1], 
    [' Alhama ',21], [' Alicante ',4], [' Allora ',33], [' Almería ',5], [' Almerimar ',5], [' Almodovar ',18], [' Almuñecar ',21], ['Alpujarra (La)',21], [' Altea  ',4], 
    [' Antequera ',33], ['Antilla (La)  ',24], [' Aranjuez ',1], [' Arenys de Mar ',10], [' Ávila ',7], [' Avilés',6], ['Badalona ',10], [' Baelo Claudia ',13], [' Baena ',18], 
    [' Barcelona ',10], [' Barciense ',47], ['Batuecas (Las)',40], [' Baza ',21], [' Bejar ',40], [' Belagua ',36], [' Belorado ',11], [' Benalmádena ',33], [' Benidorm  ',4], 
    [' Bilbao ',50], [' Bolonia ',13], [' Borja ',52], [' Briviesca ',11], [' Bubión ',21], [' Burgos ',11], [' Burjasot ',48], ['Cabra ',18], ['Cabrera (La)  ',9], [' Cáceres ',12], 
    [' Cádiz ',13], [' Calahonda ',21], ['Calahorra (La)  ',21], [' Calpe  ',4], ['Campello (El)',4], [' Candelario ',40], [' Capileira ',21], [' Carihuela ',33], [' Cariñena ',52], 
    [' Carmona  ',43], [' Carratraca ',33], [' Cartagena ',35], [' Casarabonela ',33], [' Casares ',33], [' Caspe ',52], [' Castell de Ferro ',21], [' Castellón ',15], [' Castillejo ',21],
    [' Castillo de Javier ',36], [' Castrojeriz ',11], [' Catalayud ',52], [' Chiclana ',13], [' Chinchón ',1], [' Ciudad Real ',17], [' Ciudad Rodrigo ',40], [' Conil de La Frontera ',13], 
    [' Consuegra ',47], [' Córdoba ',18], ['Coruña (A)',27], [' Covarrubias ',11], [' Cuenca ',19], [' Cugat ',10], ['Daroca ',52], [' Denia  ',4], ['Écija  ',43], 
    [' Ejea de los Caballeros ',52], [' Escalona ',47], [' Escatrón ',52], ['Escorial (El)',1], [' Espejo ',18], [' Espinosa de los Monteros ',11], [' Esquivias ',47], [' Estella ',36], 
    [' Estepona ',33], ['Figueres ',20], [' Finestrat  ',4], [' Formentera',9], [' Frías ',11], [' Fuengirola ',33], [' Fuerteventura',29], [' Fuentetodos ',52], ['Gijón',6], 
    ['Girona',20], [' La Gomera',41], [' Granada ',21], [' Gran Canaria ',29], [' Guadalajara ',22], [' Guadalupe',12], [' Guadamur ',47], [' Guadix ',21], [' Guardamar del Segura  ',4], 
    ['Herradura (La)',21], ['Hierro (El)',41], [' Huelva ',24], [' Huesca ',25], [' Huéscar ',21], ['Ibiza',9], [' Illanoz ',21], ['Illescas ',47], [' Illora ',21], 
    [' Isla Canela ',24], [' Isla Cristina ',24], [' Islantilla ',24], [' Itálica  ',43], [' Isaba ',36], [' Itero ',11], ['Jaén ',26], [' Játiva ',48], [' Jávea  ',4], 
    [' Jerez de la Frontera ',13], ['Lagartera ',47], [' Lanjarón ',21], [' Lanzarote ',29], [' León ',30], ['Lleida',31], [' Lerma ',11], ['Lloret de Mar ',20], 
    [' Logroño',28], [' Loja ',21], [' Lugo ',32], [' Málaga ',33], [' Mallorca',9], ['Manga (La)',35], [' Maqueda ',47], ['Marbella ',33], 
    [' Mataró ',10], [' Matalascañas ',24], [' Mazarrón ',35], [' Mecina ',21], [' Medina Azahara ',18], [' Medina de Pomar ',11], [' Menorca',9], ['Mérida ',8], 
    [' Mijas ',33], [' Miranda del Castañar ',40], [' Mogarraz ',40], [' Montefrío ',21], [' Montilla ',18], [' Montoro ',18], [' Montserrat ',10], ['Moradillo de Sedano ',11], 
    [' Morella ',15], [' Moriles ',18], [' Murcia ',35], ['Nerja ',33], [' Nuevalos ',52], [' Nuevo Portil ',24], ['Ocaña ',47], ['Ochagavía',36], ['Ojén',33], 
    [' Olite ',36], [' Olmillos ',11], [' Ourense ',37], [' Orgaz ',47], [' Oropesa ',15], [' Oropesa ',47], [' Orvija ',21], [' Osuna  ',43], [' Oviedo ',6], ['Palencia ',38], 
    ['Palma (La) ',41], [' Palmar ',48], [' Palos de la Frontera ',24], [' Pampaneira ',21], [' Pamplona ',36], [' Penedés ',10], [' Peñaranda del Duero ',11], [' Peñíscola ',15],
    [' Pilar de Horadada  ',4], [' Pinos Puente ',21], [' Pizarra ',33], [' Plasencia',12], [' Pontevedra ',39], [' Priego ',18], [' Puentearenas ',11], [' Puente del Arzobispo ',47],
    [' Puente la Reina ',36], [' Puerto Banús ',33], ['Puerto de Santa María (El)',13], [' Punta Umbría ',24], ['Quintanar de la Orden ',47], [' Quintanilla de las Viñas ',11], 
    ['Rábida (La)',24], [' Rebolledo de la Torre ',11], [' Redecilla del Camino ',11], [' Rincón de la Victoria ',33], [' Roquetas de Mar ',5], ['Rompido (El)  ',24], 
    [' Roncal ',36], [' Roncesvalles ',36], [' Ronda ',33], [' Rota ',13], ['Sabadell ',10], [' Sagunto ',48], [' San José del Monte ',40], [' San Juan de Ortega ',11], 
    [' Salamanca ',40], [' Salas de los Infantes ',11], [' Salobreña ',21], [' Sangüesa ',36], [' San Pedro de Alcántara ',33], [' San Salvador de Leyre ',36], 
    [' San Sebastián ',23], [' Santa Fe ',21], [' Santa Pola  ',4], [' Santander',14], [' Santiago de Compostela ',27], [' Santillana del Mar ',14], 
    [' Santiponce  ',43], [' Sant Pere de Ribes ',10], [' Sant Sadurní d Anoia ',10], [' Sedano ',11], [' Segovia ',42], [' Sequeros ',40], [' Sevilla ',43], 
    [' Sigüenza ',22], [' Sierra Nevada ',21], [' Silos ',11], [' Sitges ',10], [' Soportuja ',21], [' Soria ',44], [' Sos del Rey Católico ',52], ['Tabarca  ',4], 
    [' Tafalla ',36], [' Talavera de la Reina ',47], [' Tarazona ',52], [' Tarifa ',13], [' Tarragona ',45], [' Tauste ',52], [' Tembleque ',47], [' Tenerife',41], 
    [' Terrasa ',10], [' Teruel ',46], ['Toboso (El)  ',47], [' Toledo ',47], [' Torcal de Antequera ',33], [' Torremolinos ',33], [' Torrenueva ',21], [' Torrevieja  ',4], 
    [' Torrijos ',47], [' Tossa de Mar ',20], ['Toyo (El)  ',5], [' Trévelez ',21], [' Trujillo',12], [' Tudela ',36], ['Ujue ',36], [' Uncastillo ',52], ['Valencia ',48],
    [' Valladolid ',49], [' Valor ',21], [' Vélez ',33], [' Vera ',5], [' Viana ',36], [' Vigo',39], [' Vilafranca ',10], [' Villafranca ',11], [' Vitoria-Gasteiz',2], 
    ['Yesa ',36], [' Yesa ',52], ['Zahara de Los Atunes ',13], [' Zamora ',51], [' Zaragoza',52]].each do |city|
         
      City.create(:name => city[0].strip, :state_id => city[1])
    end
              
              
    include GeoKit::Geocoders      
    
    the_markers = Marker.find(:all, :conditions => "region is null or region = ''")
    the_markers.each do |marker|
      
      @location = GoogleGeocoder.reverse_geocode([marker.lat, marker.lng])      
      puts "#{marker.region} => #{@location.state}"
      puts marker.name
      marker.region = @location.state
      marker.save

    end
      
end