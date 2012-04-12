# to run:    rake the_update_slugs

desc "update all tables w/ slugs"
task :the_update_slugs => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	##############################################################################################################################################################################
	# remove in production...
	# select * from roles_users where user_id = 2001	and role_id in (	select id	from roles where name = 'manager' 	and authorizable_type = 'Group'	and authorizable_id = 14)

	RolesUsers.create(:user_id => 2001, :role_id => 72608)
  ##############################################################################################################################################################################

	the_duplicates = []

	the_slug_user_duplicate = Slug.find(:all, :select =>"sluggable_id", :conditions => ["sluggable_type = 'User'"], :group => "sluggable_type, sluggable_id", :having =>"count(*) > 1")
	the_slug_user_duplicate.each {|duplicate| the_duplicates << duplicate.sluggable_id}

	the_slug_user_duplicate = Slug.find(:all, :select => "sluggable_id", :conditions => "sluggable_type = 'User' and name in (select name FROM slugs WHERE sluggable_type = 'User' GROUP by name	HAVING count(*) > 1 ) ")
	the_slug_user_duplicate.each {|duplicate| the_duplicates << duplicate.sluggable_id}

	# the_duplicates.each {|dups| puts dups; puts}


	the_slugs = Slug.find(:all, :conditions => "sluggable_type not in ('Blog','Forum')", :order => 'sluggable_type, sluggable_id')
	the_slugs.each do |slug|

		puts "sluggable_type => #{slug.sluggable_type} - #{slug.sluggable_id}"

		the_model = nil 
		the_slug_name = slug.name

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
			the_model.updated_at = Time.zone.now - 90.days
			the_model.save
		end

	end

end
