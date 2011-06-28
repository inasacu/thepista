desc "Replace the session secret"
task :new_secret => :environment do
  new_secret = ActiveSupport::SecureRandom.hex(64)
  config_file_name = File.join(RAILS_ROOT, 'config', 'environment.rb')
  config_file_data = File.read(config_file_name)
  File.open(config_file_name, 'w') do |file|
    file.write(config_file_data.sub('568868b6d22dbdaab2e6e783d4da45f6c466dad1e0184b4836c9f3affdab2dac3e49005c6ebd080c1f0c309d89896fb2973c70fe743fbb1df6557ba25dcdab64', new_secret))
  end
end

desc 'Load an initial set of data and ready the app'
task :bootstrap => :environment do
  Rake::Task["db:schema:load"].invoke

  puts "\n\nReplacing session secret..."  
  Rake::Task["new_secret"].invoke
end