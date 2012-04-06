# to run:    rake the_archive_slug

desc "ARCHIVE dependent records to already archived"
task :the_archive_slug => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  
  has_to_archive = true
  
  # ARCHIVE all slugs for all sluggable_type archived 
  the_item_types = Slug.find(:all, :select => "distinct sluggable_type")
  the_item_types.each do |slug|
    
    # puts "sluggable_type => #{slug.sluggable_type}"
    the_archive = []    
    
    case slug.sluggable_type
    when "User"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'User' and sluggable_id in (select id from users where archive = true)")
    when "Group"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Group' and sluggable_id in (select id from groups where archive = true)")
    when "Challenge"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Challenge' and sluggable_id in (select id from challenges where archive = true)")
    when "Escuadra"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Escuadra' and sluggable_id in (select id from escuadras where archive = true)")
    when "Schedule"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Schedule' and sluggable_id in (select id from schedules where archive = true)")
    when "Blog"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Blog' and sluggable_id in (select id from blogs where archive = true)")
    when "Fee"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Fee' and sluggable_id in (select id from fees where archive = true)")
    when "Payment"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Payment' and sluggable_id in (select id from payments where archive = true)")
    when "Cup"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Cup' and sluggable_id in (select id from cups where archive = true)")
    when "Game"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Game' and sluggable_id in (select id from games where archive = true)")
    when "Forum"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Forum' and sluggable_id in (select id from forums where archive = true)")
    when "Venue"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Venue' and sluggable_id in (select id from venues where archive = true)")
    when "Installation"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Installation' and sluggable_id in (select id from installations where archive = true)")
    when "Classified"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "sluggable_type = 'Classified' and sluggable_id in (select id from classifieds where archive = true)")
    end
     
    the_archive.each do |slug|
      puts "ARCHIVE slug => #{slug.id},  #{slug.sluggable_id} #{slug.sluggable_type}"
      slug.archive = true
      slug.save if has_to_archive
    end
  end

end
