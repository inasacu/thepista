

render :rpx_new



# Centro Deportivo Municipal La Elipa
	@new_venue = Venue.new
	@new_venue.name = 'Centro Deportivo Municipal La Elipa'
	@new_venue.short_name = 'C.D.M. La Elipa'
	@new_venue.starts_at = '2012-09-20 06:00:00'
	@new_venue.ends_at = '2012-09-20 21:30:00'
	@new_venue.marker_id = 48
	@new_venue.description = 'Gestión por parte del Ayuntamiento de Madrid
														Dirección: CALLE  ALCALDE GARRIDO JUARISTI, 28030  MADRID 
														Barrio / Distrito:  MEDIA LEGUA / MORATALAZ
														Teléfono: 914 303 511
	
														EQUIPAMIENTOS
	
														Unidades Deportivas al aire libre
														Bolera Asturiana - Campo de Béisbol -  2 Campos de Fútbol (de césped artificial) - 2 Campos de Fútbol 7 (de césped artificial) - Campo de Sófbol - 2 Circuitos de Aeromodelismo (Radiocontrol de asfalto / radio control de tierra, con cubierta) - Piscina (vaso de 50 metros, vaso de recreo y vaso infantil) - 4 Pistas de Pádel - Pista Polideportiva - 10 Pistas de Tenis - 11 Tenis Mesa - Zona Nudista
	
														Unidades Deportivas Cubiertas
														Frontón - Pabellón Polideportivo - 2 Salas multiusos (gimnasios) - Sala de Musculación'
	@new_venue.save
# Campo 1 A
	@new_installation = Installation.new
	@new_installation.name = 'Campo 1 A'
	@new_installation.venue_id = @new_venue.id
	@new_installation.marker_id = @new_venue.marker_id
	@new_installation.sport_id = 2
	@new_installation.starts_at = @new_venue.starts_at
	@new_installation.ends_at = @new_venue.ends_at
	@new_installation.timeframe = 1
	@new_installation.fee_per_pista = 30.6
	@new_installation.fee_per_lighting = 3.25
	@new_installation.public = true
	@new_installation.lighting = true
	@new_installation.outdoor = true
	@new_installation.description = 'Campo de Fútbol 11 - Cesped Artificial'
	@new_installation.conditions = 'Requiere botas especificas para cesped Artificial'
	@new_installation.save



