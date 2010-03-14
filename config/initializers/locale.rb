
# tell the I18n library where to find your translations
I18n.load_path << Dir[ File.join(RAILS_ROOT, 'lib', 'locales', '*.{rb,yml}') ]
 
# set default locale to something other than :en
I18n.default_locale = :es

# languages currently supported
LANGUAGES = ['en', 'es']