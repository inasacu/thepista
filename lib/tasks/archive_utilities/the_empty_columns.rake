# to run:    heroku run rake the_empty_columns -a thepista

desc "identify all fields in table that are null"
task :the_empty_columns => :environment do |t|

	# ignore_field_names = ['id', 'archive', '_at', '_score', 'roster_position', 'played']
	ignore_field_names = ['id']

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	connection = ActiveRecord::Base.connection

	connection.tables.each do |table|
		connection.columns(table).each do |column|

			go_to_next = false
			ignore_field_names.each do |ignore|
				go_to_next = column.name.include?(ignore) unless go_to_next
			end
			next if go_to_next
			
			
			if ActiveRecord::Base.connection.execute(query table, column).to_a.empty?
				puts "#{table} | #{column.name}"
			end

		end
	end

end


def query table, column
# "select #{table}.#{column.name} from #{table} where #{table}.#{column.name} is not null or #{table}.#{column.name} != '' limit 1"
	"select #{table}.#{column.name} from #{table} where #{table}.#{column.name} is not null limit 1"
end


