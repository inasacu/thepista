# to run:    sudo rake the_archive_role

desc "ARCHIVE dependent records to already archived"
task :the_archive_role => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # # ARCHIVE all roles for all authorizable_type archived 
  # the_item_types = Role.find(:all, :select => "distinct authorizable_type")
  # the_item_types.each do |role|
  #   puts "authorizable_type => #{role.authorizable_type}"
  #   the_archive = []    
  #   case role.authorizable_type
  #   when "User"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'User' and authorizable_id in (select id from users where archive = true)")
  #   when "Group"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Group' and authorizable_id in (select id from groups where archive = true)")
  #   when "Challenge"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Challenge' and authorizable_id in (select id from challenges where archive = true)")
  #   when "Schedule"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Schedule' and authorizable_id in (select id from schedules where archive = true)")
  #   when "Blog"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Blog' and authorizable_id in (select id from blogs where archive = true)")
  #   when "Fee"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Fee' and authorizable_id in (select id from fees where archive = true)")
  #   when "Payment"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Payment' and authorizable_id in (select id from payments where archive = true)")
  #   when "Cup"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Cup' and authorizable_id in (select id from cups where archive = true)")
  #   when "Game"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Game' and authorizable_id in (select id from games where archive = true)")
  #   when "Forum"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Forum' and authorizable_id in (select id from forums where archive = true)")
  #   when "Marker"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Marker' and authorizable_id in (select id from markers where archive = true)")
  #   when "Classified"
  #     the_archive = Role.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and authorizable_type = 'Classified' and authorizable_id in (select id from classifieds where archive = true)")
  #   end  
  #   the_archive.each do |role|
  #     puts "ARCHIVE role => #{role.id},  #{role.authorizable_id} #{role.authorizable_type}"
  #     role.archive = true
  #     role.save if has_to_archive
  #   end
  # end
  # 
  # # ARCHIVE all roles_users for roles archived 
  # the_archive = RolesUsers.find(:all, :select => "distinct *", 
  # :conditions => "archive = false and role_id in (select id from roles where archive = true)")
  # the_archive.each do |role_user|
  #   puts "ARCHIVE role_user => #{role_user.id}, #{role_user.role_id}"
  #   role_user.archive = true
  #   role_user.save if has_to_archive
  # end
end
