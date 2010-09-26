# to run:    sudo rake the_slugs

desc "  # clear foto for dev and test"
task :the_slugs => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # rake friendly_id:make_slugs MODEL=Blog
  # rake friendly_id:make_slugs MODEL=Forum
  # rake friendly_id:make_slugs MODEL=Challenge
  # rake friendly_id:make_slugs MODEL=Classified
  # rake friendly_id:make_slugs MODEL=Cup
  # rake friendly_id:make_slugs MODEL=Escuadra
  # rake friendly_id:make_slugs MODEL=Game
  # rake friendly_id:make_slugs MODEL=Group
  # rake friendly_id:make_slugs MODEL=Marker
  # rake friendly_id:make_slugs MODEL=Payment
  # rake friendly_id:make_slugs MODEL=Schedule
  # rake friendly_id:make_slugs MODEL=User

  # rake friendly_id:redo_slugs MODEL=Blog
  # rake friendly_id:redo_slugs MODEL=Forum
  # rake friendly_id:redo_slugs MODEL=Challenge
  # rake friendly_id:redo_slugs MODEL=Classified
  # rake friendly_id:redo_slugs MODEL=Cup
  # rake friendly_id:redo_slugs MODEL=Escuadra
  # rake friendly_id:redo_slugs MODEL=Game
  # rake friendly_id:redo_slugs MODEL=Group
  # rake friendly_id:redo_slugs MODEL=Marker
  # rake friendly_id:redo_slugs MODEL=Payment
  # rake friendly_id:redo_slugs MODEL=Schedule
  # rake friendly_id:redo_slugs MODEL=User

  # fixing blog name issues before slugs are generated
  Blog.find(:all, :conditions => "name like '%...%'").each do |blog|

    unless blog.user_id == nil
      user = User.find(:first, :conditions => ["id = ?", blog.user_id])
      
      if user.blank?
        puts "blog id:  #{blog.id} needs to be deleted..."
        blog.destroy
      else
        blog.item = user
        blog.name = user.name
        blog.description = user.name
        blog.save!
        puts "blog id:  #{blog.id} get a name change..." 
      end
      
    end
    

  end

end

