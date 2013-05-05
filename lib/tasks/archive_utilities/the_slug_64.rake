# to run:   	 	rake the_slug_64
# to run:    		rake the_archive_dependent
# to run:    		rake the_archive_role
# to run:    		rake the_remove_archive_data



desc "update all table slugs with name"
task :the_slug_64 => :environment do |t|

	@host = Rails.env.production? ? 'haypista' : 'thepista' 
	@host = ''
		
	# to regenerate use the below
	Schedule.find_each(&:save)

	# USER
	the_models = User.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.message_notification = true
		model.password = set_block_encode_decode(model) 								if model.password.nil?
		model.password_confirmation = set_block_encode_decode(model) 		if model.password_confirmation.nil?
		model.save!
	end

	# VENUES
	the_models = Venue.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.description = model.description.to_s.strip[0..255] 			#if model.description.nil?
		model.save!
	end
	
	# GROUPS
	the_models = Group.all
	the_models.each do |model|	
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# SCHEDULE
	the_models = Schedule.all
	the_models.each do |model|	
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# FEE
	the_models = Fee.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# PAYMENT
	the_models = Payment.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# INSTALLATIONS
	the_models = Installation.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# CUP
	the_models = Cup.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# GAME
	the_models = Game.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# ESCUADRA
	the_models = Escuadra.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# MARKER
	the_models = Marker.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# CHALLENGE
	the_models = Challenge.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# CASTS
	# the_models = Cast.all
	# the_models.each do |model|
	# 	model.slug = set_block_encode_decode(model)
	# 	model.save!
	# end


	# ENCHUFADOS
	the_models = Enchufado.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	# SUBPLUGS
	the_models = Subplug.all
	the_models.each do |model|
		model.slug = set_block_encode_decode(model)
		model.save!
	end
	
	
end

def set_block_encode_decode(model)
	
	block_encode = nil
	block_decode = nil
	
	the_encode = "#{@host}#{model.name}#{model.id}"
	
	block_encode = Base64.urlsafe_encode64(the_encode)	
	block_decode = Base64.urlsafe_decode64(block_encode.to_s) 
	
	block_decode.encoding
	block_decode.force_encoding 'utf-8'
	block_decode = block_decode.to_s.gsub(@host,'').gsub(model.name,'')
		
	puts "#{model.class.to_s}: #{block_decode} => #{block_encode}"
		
	return block_encode
end
