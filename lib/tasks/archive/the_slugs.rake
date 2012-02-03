# to run:    sudo rake the_slugs

desc "  # create slugs for all models"
task :the_slugs => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  the_make_slugs = true
  the_redo_slugs = true
  the_remove_old_slugs = true

  # if the_make_slugs
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
    # rake friendly_id:make_slugs MODEL=Venue
    # rake friendly_id:make_slugs MODEL=Installation
  # end

  # if the_redo_slugs
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
    # rake friendly_id:redo_slugs MODEL=Venue
    # rake friendly_id:redo_slugs MODEL=Installation
  # end

  # if the_remove_old_slugs
  #   rake friendly_id:remove_old_slugs
  # end

end

