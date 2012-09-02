# to run:    heroku run rake the_add_type_values -a thepista

desc "add values to types..."
task :the_add_type_values => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	
	# sql = "INSERT INTO types (id, name, table_type) values (51, 'Core', 'Group')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# sql = "INSERT INTO types (id, name, table_type) values (52, 'Fremium', 'Group')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# sql = "INSERT INTO types (id, name, table_type) values (53, 'Professional', 'Group')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# sql = "INSERT INTO types (id, name, table_type) values (54, 'HayPista', 'Group')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# sql = "INSERT INTO types (id, name, table_type) values (61, 'Anyone', 'Venue')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# sql = "INSERT INTO types (id, name, table_type) values (62, 'Registered', 'Venue')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# sql = "INSERT INTO types (id, name, table_type) values (63, 'Verified', 'Venue')"
	# ActiveRecord::Base.connection.insert_sql sql
	# 
	# the_types = Type.find(:all, :conditions => "id > 40")
	# the_types.each do |type|
	# 	type.created_at = Time.zone.now
	# 	type.updated_at = Time.zone.now
	# 	type.save
	# end
	
end

