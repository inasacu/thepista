# to run:    rake the_update_slugs

desc "update all tables w/ slugs"
task :the_update_slugs => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	the_slugs = Slug.find(:all, :conditions => "sluggable_type not in ('Blog','Forum')", :order => 'sluggable_type, sluggable_id')
	the_slugs.each do |slug|

		puts "sluggable_type => #{slug.sluggable_type} - #{slug.sluggable_id}"

		the_model = nil 
		the_slug_name = slug.name
		the_duplicates = [3072, 12, 106, 2913, 2917, 2938, 2962, 2991]

		case slug.sluggable_type
		when "Venue"
			the_model = Venue.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = the_slug_name
			the_model.description = the_model.description.to_s.strip[0..1999]
		when "Installation"
			the_model = Installation.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = the_slug_name

		when "Group"
			the_model = Group.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = the_slug_name
		when "Escuadra"
			the_model = Escuadra.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = the_slug_name
		when "Schedule"
			the_model = Schedule.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"
			is_name = false
		when "Cup"
			the_model = Cup.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = the_slug_name
		when "Game"
			the_model = Game.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"
		when "Marker"
			the_model = Marker.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = the_slug_name

		when "Challenge"
			the_model = Challenge.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"
		when "Fee"
			the_model = Fee.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"
		when "Payment"
			the_model = Payment.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"
		when "Match"
			the_model = Match.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"
		when "Classified"
			the_model = Classified.find(:first, :conditions => ["id = ?", slug.sluggable_id])
			the_model.slug = "#{the_slug_name}_#{slug.id}"

		when "User"
			the_model = User.find(:first, :conditions => ["id = ?", slug.sluggable_id])

			the_model.slug = the_duplicates.include?(slug.sluggable_id) ? "#{the_slug_name}_#{slug.id}"  : the_slug_name

			if the_model.password.nil?
				the_model.password = the_model.email 
				the_model.password_confirmation = the_model.email 
			end
		end

		unless the_model.nil?
			puts "#{the_model.class.to_s} => #{the_model.slug}" 
			the_model.save
		end

	end

end
