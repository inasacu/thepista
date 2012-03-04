# to run:    sudo rake the_image_verification

require 'uri'
require 'net/http'


# method picks gets a model and will determine if the image exist on the s3 server
def verify_image_url(the_item, the_controller="")	
  has_correct_url = false
  # the_controller = get_the_controller(the_item)

  the_item_url = "/:assets/#{the_controller}/#{the_item.id}/original.gif"
  the_url = "#{@the_s3_url}#{@the_bucket_url}#{the_item_url}"

  # the_url = "http://s3.amazonaws.com/thepista_desarrollo/:assets/users/2001/original.gif"
  # http://s3.amazonaws.com/thepista_desarrollo/:assets/users/2001/rockstar_yellow.gif  

  url = URI.parse(the_url)

  puts "the_url:  #{the_url}"
  Net::HTTP.start(url.host, url.port) do |http|
    response = http.head(url.path)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      case response.content_type
      when "image/png", "image/gif", "image/jpeg"
        puts "#{the_controller} image OK..."
        has_correct_url = true
      else
        puts "#{the_controller} image ISSUE..."
        # has_correct_url = false
      end
    else
      puts "#{the_controller} image ISSUE..."
      # has_correct_url = false
    end
  end
  return has_correct_url
end

desc "archive dependent records to already archived"
task :the_image_verification => :environment do |t|


  # Load custom config file for current environment
  S3_CREDENTIALS = File.read("#{Rails.root}/config/s3.yml")
  S3_CONFIG = YAML.load(S3_CREDENTIALS)[Rails.env]

  @the_s3_url = "http://s3.amazonaws.com/"
  @the_bucket_url = S3_CONFIG['bucket']

  # the_model_url = "/:assets/#{get_the_controller(item)}/#{item.id}/#{item.photo_file_name}"
  # the_url = "#{@the_s3_url}#{@the_bucket_url}#{the_model_url}"

  # example
  # http://s3.amazonaws.com/thepista_produccion/:assets/users/2902/original.JPG?1259665759
  # url = URI.parse("http://example.com/images/yer_img_here.foo")


  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  # verify user pictures still active
  the_item = User.find(:all, :select => "id, photo_file_name", :conditions => "photo_file_name is not null")
  puts "Users"
  the_item.each do |item|
    unless verify_image_url(item, "users") 
      puts item.name
      # item.photo_file_name = nil
      # item.photo_content_type = nil
      # item.photo_file_size = nil
      # item.photo_updated_at = nil
      # item.save!
    end  
  end

  # verify group pictures still active
  the_item = Group.find(:all, :conditions => "photo_file_name is not null")
  puts "Groups"
  the_item.each do |item|
    unless verify_image_url(item, "groups") 
      puts item.name
      # item.photo_file_name = nil
      # item.photo_content_type = nil
      # item.photo_file_size = nil
      # item.photo_updated_at = nil
      # item.save!
    end  
  end

  # verify escuadras pictures still active
  the_item = Escuadra.find(:all, :conditions => "photo_file_name is not null")
  puts "Escuadras"
  the_item.each do |item|
    unless verify_image_url(item, "escuadras") 
      puts item.name
      # item.photo_file_name = nil
      # item.photo_content_type = nil
      # item.photo_file_size = nil
      # item.photo_updated_at = nil
      # item.save!
    end  
  end

  # verify cups pictures still active
  the_item = Cup.find(:all, :conditions => "photo_file_name is not null")
  puts "Cups"
  the_item.each do |item|
    unless verify_image_url(item, "cups") 
      puts item.name
      # item.photo_file_name = nil
      # item.photo_content_type = nil
      # item.photo_file_size = nil
      # item.photo_updated_at = nil
      # item.save!
    end  
  end

  # verify venues pictures still active
  the_item = Venue.find(:all, :conditions => "photo_file_name is not null")
  puts "Venues"
  the_item.each do |item|
    unless verify_image_url(item, "venues") 
      puts item.name
      # item.photo_file_name = nil
      # item.photo_content_type = nil
      # item.photo_file_size = nil
      # item.photo_updated_at = nil
      # item.save!
    end  
  end

end