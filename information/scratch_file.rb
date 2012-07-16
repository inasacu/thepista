


# local development

rake db:migrate
rake the_archive_dependent
rake the_archive_role
rake the_remove_archive_data
rake the_slug_64

# zurb.herokuapp.com

heroku pgbackups:restore DATABASE `heroku pgbackups:url --app haypista` --app zurb


heroku run rake db:migrate --app zurb
heroku run rake the_archive_dependent --app zurb
heroku run rake the_archive_role --app zurb
heroku run rake the_remove_archive_data --app zurb
heroku run rake the_slug_64 --app zurb

heroku restart --app zurb



