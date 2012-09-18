require 'rubygems'
require 'sitemap_generator'




# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://haypista.com"
SitemapGenerator::Sitemap.yahoo_app_id = "_em2vb_V34GL_0QXEPTfW2cakP6xLp8jAah_o5dJkAn8o1Ko_dtmNY1ky85Iv0tXWzwI"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly', 
  #           :lastmod => Time.now, :host => default_host


  # Examples:

  # add '/articles'
  # sitemap.add articles_path, :priority => 0.7, :changefreq => 'daily'

  # add all individual articles
  # Article.find(:all).each do |a|
  #   sitemap.add article_path(a), :lastmod => a.updated_at
  # end

  # add merchant path
  # sitemap.add '/purchase', :priority => 0.7, :host => "https://haypista.com"

  # add users
  User.find_in_batches(:batch_size => 1000) do |users|
    users.each do |user|
      sitemap.add user_path(user), :lastmod => user.updated_at, :changefreq => 'weekly'
    end
  end

  # add groups
  Group.find_in_batches(:batch_size => 1000) do |groups|
    groups.each do |group|
      sitemap.add group_path(group), :lastmod => group.updated_at, :changefreq => 'weekly'
    end
  end

  # add schedules
  Schedule.find_in_batches(:batch_size => 1000) do |schedules|
    schedules.each do |schedule|
      sitemap.add schedule_path(schedule), :lastmod => schedule.updated_at, :changefreq => 'weekly'
    end
  end

  # add cups
  Cup.find_in_batches(:batch_size => 1000) do |cups|
    cups.each do |cup|
      sitemap.add cup_path(cup), :lastmod => cup.updated_at, :changefreq => 'weekly'
    end
  end
  
  # add challenges
  Challenge.find_in_batches(:batch_size => 1000) do |challenges|
    challenges.each do |challenge|
      sitemap.add challenge_path(challenge), :lastmod => challenge.updated_at, :changefreq => 'weekly'
    end
  end
  
  # add classifieds
  # Classified.find_in_batches(:batch_size => 1000) do |classifieds|
  #   classifieds.each do |classified|
  #     sitemap.add classified_path(classified), :lastmod => classified.updated_at, :changefreq => 'weekly'
  #   end
  # end
  
  # add escuadras
  Escuadra.find_in_batches(:batch_size => 1000) do |escuadras|
    escuadras.each do |escuadra|
      sitemap.add escuadra_path(escuadra), :lastmod => escuadra.updated_at, :changefreq => 'weekly'
    end
  end
  
  # You can run rake sitemap:refresh as needed to create Sitemap files. 
  # This will also ping all the 'major' search engines. 
  # (if you want to disable all non-essential output run the rake task thusly rake -s sitemap:refresh)
  # 
  # Sitemaps with many urls (100,000+) take quite a long time to generate, so if you need to refresh your Sitemaps regularly you can set the rake task up as a cron job. Most cron agents will only send you an email if there is output from the cron task.
  # 
  # Optionally, you can add the following to your robots.txt file, so that robots can find the sitemap file.
  # 
  # Sitemap: <hostname>/sitemap_index.xml.gz

end

SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'daily', :priority => 0.9
  add '/contact_us', :changefreq => 'weekly'
end
SitemapGenerator::Sitemap.ping_search_engines # called for you when you use the rake task