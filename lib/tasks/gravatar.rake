# to run:    sudo rake gravatar_cache

# http://macournoyer.wordpress.com/category/ruby/rails/
# gravatar_cache plugin
# ruby script/plugin install http://code.macournoyer.com/svn/plugins/gravatar_cache

#################################################################################
# in plugin this code needs to be modified

# URL to the Gravatar...
#  - in cache if cached
#  - to default image if no email
# You need to setup a symlink from public/gravatars to tmp/cache/gravatars for this to work
# def url
#   return default if email.blank? || !ActionController::Base.perform_caching
#   
#   # If no yet cached, creates a place holder for when it is.
#   # So it is usable inside a cached page.
#   symlink_to_default unless cached?
#   
#   "gravatars/#{id}.gif"
# end
# 
# def url
#   return default if email.blank?
#   gravatar_url
# end
#################################################################################

desc "wget's the gravatars for all the user emails in your database. call with RAILS_ENV=production or it defaults to development"
task :gravatar_cache => :environment do |t|
 
  require 'gravatar'
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  users = (User.find :all).collect {|u| u if u.email? }.compact
  users.each do |user|
    
    theGravatar = Gravatar.new(user.email)
    if theGravatar.has_gravatar? and user.default_avatar != theGravatar.url
      user.default_avatar = theGravatar.url 
      user.has_gravatar = true            
      puts "updated #{user.name } HAS gravatar id..."      
      user.save!
    else 
      user.has_gravatar = false
      user.default_avatar = "default_avatar.jpg" 
      puts "updated #{user.name } DOES NOT have a gravatar id..."
      user.save!
    end
    
    #sleep(1) # you know, to play nice with gravatar.com if you have a gazillion records
  end
end
