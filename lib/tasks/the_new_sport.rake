# to run:    sudo rake the_new_sport

desc "  # add new sports to list"
task :the_new_sport => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  [['Handball', 'Balonmano, Handball', 'futbol.gif', 1,  0,  0,  12], ['Baseball', 'Beisbol, Baseball', 'baseball.jpg', 1,  0,  0,  16],
  ['Rugby', 'Rugby', 'football.gif',  1,  0,  0,  30]].each do |sport|
    Sport.create(:name => sport[0], :description => sport[1], :icon => sport[2],	
    :points_for_win => sport[3], :points_for_lose => sport[4], :points_for_draw => sport[5], :player_limit => sport[6] )

  end

  the_sport = Sport.find(8)
  the_sport.icon = 'volleyball.png'
  the_sport.player_limit = 12
  the_sport.save

  the_sport = Sport.find(1)
  the_sport.player_limit = 14
  the_sport.save

  the_sport = Sport.find(12)
  the_sport.player_limit = 4
  the_sport.save

  the_sport = Sport.find(:all, :conditions => "id in (2,4,5)")
  the_sport.each do |sport|
    sport.player_limit = 22
    sport.save
  end

  the_sport = Sport.find(:all, :conditions => "id in (3,7,10)")
  the_sport.each do |sport|
    sport.player_limit = 10
    sport.save
  end

  the_sport = Sport.find(:all, :conditions => "id in (6,9,11)")
  the_sport.each do |sport|
    sport.player_limit = 2
    sport.save
  end



  # [['Madrid'],['Álava'],['Albacete'],['Alicante'],['Almería'],['Asturias'],['Ávila'],['Badajoz'],['Illes Baleares'],['Barcelona'],['Burgos'],
  # ['Cáceres'],['Cádiz'],['Cantabria'],['Castellón'],['Ceuta'],['Ciudad Real'],['Córdoba'],['Cuenca'],['Girona'],['Granada'],['Guadalajara'],['Guipúzcoa'],
  # ['Huelva'],['Huesca'],['Jaén'],['La Coruña'],['La Rioja'],['Las Palmas'],['León'],['Lleida'],['Lugo'],['Málaga'],['Melilla'],['Murcia'],['Navarra'],
  # ['Ourense'],['Palencia'],['Pontevedra'],['Salamanca'],['Santa Cruz de Tenerife'],['Segovia'],['Sevilla'],['Soria'],['Tarragona'],['Teruel'],
  # ['Toledo'],['Valencia'],['Valladolid'],['Vizcaya'],['Zamora'],
  # ['Zaragoza']].each do |state|
  #   State.create(:name => state[0])
  # end
  # 
  # 
  # [['Madrid'],['La Acebeda'],['Ajalvir'],['Alameda del Valle'],['El Álamo'],['Alcalá de Henares'],['Alcobendas'],['Alcorcón'],['Aldea del Fresno'],['Algete'],['Alpedrete'],['Ambite'],['Anchuelo'],['Aranjuez'],['Arganda del Rey'],['Arroyomolinos'],['El Atazar'],['Batres'],['Becerril de la Sierra'],['Belmonte de Tajo'],['El Berrueco'],['Berzosa del Lozoya'],['Boadilla del Monte'],['El Boalo'],['Braojos'],['Brea de Tajo'],['Brunete'],['Buitrago del Lozoya'],['Bustarviejo'],['Cabanillas de la Sierra'],['La Cabrera'],['Cadalso de los Vidrios'],['Camarma de Esteruelas'],['Campo Real'],['Canencia'],['Carabaña'],['Casarrubuelos'],['Cenicientos'],['Cercedilla'],['Cervera de Buitrago'],['Chapinería'],['Chinchón'],['Ciempozuelos'],['Cobeña'],['Collado Mediano'],['Collado Villalba'],['Colmenar de Oreja'],['Colmenar del Arroyo'],['Colmenar Viejo'],['Colmenarejo'],['Corpa'],['Coslada'],['Cubas de la Sagra'],['Daganzo de Arriba'],['El Escorial'],['Estremera'],['Fresnedillas de la Oliva'],['Fresno de Torote'],['Fuenlabrada'],['Fuente el Saz de Jarama'],['Fuentidueña de Tajo'],['Galapagar'],['Garganta de los Montes'],['Gargantilla del Lozoya y Pinilla de Buitrago'],['Gascones'],['Getafe'],['Griñón'],['Guadalix de la Sierra'],['Guadarrama'],['La Hiruela'],['Horcajo de la Sierra'],['Horcajuelo de la Sierra'],['Hoyo de Manzanares'],['Humanes de Madrid'],['Leganés'],['Loeches'],['Lozoya'],['Lozoyuela-Navas-Sieteiglesias'],['Madarcos'],['Majadahonda'],['Manzanares el Real'],['Meco'],['Mejorada del Campo'],['Miraflores de la Sierra'],['El Molar'],['Los Molinos'],['Montejo de la Sierra'],['Moraleja de Enmedio'],['Moralzarzal'],['Morata de Tajuña'],['Móstoles'],['Navacerrada'],['Navalafuente'],['Navalagamella'],['Navalcarnero'],['Navarredonda y San Mamés'],['Navas del Rey'],['Nuevo Baztán'],['Olmeda de las Fuentes'],['Orusco de Tajuña'],['Paracuellos de Jarama'],['Parla'],['Patones'],['Pedrezuela'],['Pelayos de la Presa'],['Perales de Tajuña'],['Pezuela de las Torres'],['Pinilla del Valle'],['Pinto'],['Piñuécar-Gandullas'],['Pozuelo de Alarcón'],['Pozuelo del Rey'],['Prádena del Rincón'],['Puebla de la Sierra'],['Puentes Viejas'],['Quijorna'],['Rascafría'],['Redueña'],['Ribatejada'],['Rivas-Vaciamadrid'],['Robledillo de la Jara'],['Robledo de Chavela'],['Robregordo'],['Las Rozas de Madrid'],['Rozas de Puerto Real'],['San Agustín del Guadalix'],['San Fernando de Henares'],['San Lorenzo de el Escorial'],['San Martín de la Vega'],['San Martín de Valdeiglesias'],['San Sebastián de los Reyes'],['Santa María de la Alameda'],['Santorcaz'],['Los Santos de la Humosa'],['La Serna del Monte'],['Serranillos del Valle'],['Sevilla la Nueva'],['Somosierra'],['Soto del Real'],['Talamanca de Jarama'],['Tielmes'],['Titulcia'],['Torrejón de Ardoz'],['Torrejón de la Calzada'],['Torrejón de Velasco'],['Torrelaguna'],['Torrelodones'],['Torremocha de Jarama'],['Torres de la Alameda'],['Tres Cantos'],['Valdaracete'],['Valdeavero'],['Valdelaguna'],['Valdemanco'],['Valdemaqueda'],['Valdemorillo'],['Valdemoro'],['Valdeolmos-Alalpardo'],['Valdepiélagos'],['Valdetorres de Jarama'],['Valdilecha'],['Valverde de Alcalá'],['Velilla de San Antonio'],['El Vellón'],['Venturada'],['Villa del Prado'],['Villaconejos'],['Villalbilla'],['Villamanrique de Tajo'],['Villamanta'],['Villamantilla'],['Villanueva de la Cañada'],['Villanueva de Perales'],['Villanueva del Pardillo'],['Villar del Olmo'],['Villarejo de Salvanés'],['Villaviciosa de Odón'],['Villavieja del Lozoya'],
  # ['Zarzalejo']].each do |city|
  #   City.create(:name => city[0], :state_id => 1)
  # end


end