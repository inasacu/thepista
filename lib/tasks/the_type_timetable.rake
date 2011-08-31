# to run:    sudo rake the_type_timetable

desc "add new entries in type table related to timetable"
task :the_type_timetable => :environment do |t|
  
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # adding more types
  [['Monday', 'Timetable'],['Tuesday', 'Timetable'],['Wednesday', 'Timetable'],['Thursday', 'Timetable'],['Friday', 'Timetable'],
    ['Saturday', 'Timetable'],['Sunday', 'Timetable'],['Holiday', 'Timetable']].each do |type|
      Type.create(:name => type[0], :table_type => type[1])
      # puts "abc"
    end
    
    the_timetables = Type.find(:all, :conditions => "table_type = 'Timetable'", :order => "id")
    the_timetables.each {|timetable| puts timetable.name }
  
end







