# to run:    sudo rake add_holiday_type

desc "add new entries in type table related to timetable"
task :add_holiday_type => :environment do |t|
  
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # adding more types
  [['Local', 'Holiday'],['Regional', 'Holiday'],['National', 'Holiday'],['International', 'Holiday']].each do |type|
      Type.create(:name => type[0], :table_type => type[1])
    end
    
    the_holidays = Type.find(:all, :conditions => "table_type = 'Holiday'", :order => "id")
    the_holidays.each {|holiday| puts holiday.name }  
    
    default_holiday_type = Type.default_holiday_type
    
    all_holidays = Holiday.find(:all)
    all_holidays.each do |holiday|
      holiday.type_id = default_holiday_type.id
      holiday.save
    end
    
end



