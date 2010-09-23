

# http://github.com/binarylogic/authlogic/issuesearch?state=open&q=I18n#issue/29
# http://logan.dk/post/398406302/fixing-authlogic-i18n

# temporary solution to following error
# moved from rails 2.3.2 to 2.3.5
# this breaks authlogic, error below:

# http://logan.dk/post/398406302/fixing-authlogic-i18n

# error on site:
# 
# wrong number of arguments (0 for 1)
# RAILS_ROOT: /disk1/home/slugs/41823_fee142f_abde/mnt
# 
# Application Trace | Framework Trace | Full Trace
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/i18n-0.3.5/lib/i18n/backend/fallbacks.rb:57:in `index'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/i18n-0.3.5/lib/i18n/backend/fallbacks.rb:57:in `extract_string_default!'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/i18n-0.3.5/lib/i18n/backend/fallbacks.rb:41:in `translate'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/i18n-0.3.5/lib/i18n.rb:208:in `translate'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/authlogic-2.1.6/lib/authlogic/i18n/translator.rb:8:in `translate'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/authlogic-2.1.6/lib/authlogic/i18n.rb:78:in `t'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/authlogic-2.1.6/lib/authlogic/session/validation.rb:78:in `ensure_authentication_attempted'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/authlogic-2.1.6/lib/authlogic/session/persistence.rb:56:in `persisting?'
# /home/slugs/41823_fee142f_abde/mnt/.gems/gems/authlogic-2.1.6/lib/authlogic/session/persistence.rb:39:in `find'
# /disk1/home/slugs/41823_fee142f_abde/mnt/app/controllers/application_controller.rb:28:in `current_user_session'
# /disk1/home/slugs/41823_fee142f_abde/mnt/app/controllers/application_controller.rb:33:in `current_user'
# /disk1/home/slugs/41823_fee142f_abde/mnt/app/controllers/application_controller.rb:19:in `set_user_language'



# config/initializers/authlogic.rb

Authlogic::I18n.translator = FixedAuthlogicI18n::Translator.new
