# 
#   http://blog.aisleten.com/2008/01/26/optimizing-solr-and-rails-index-in-the-background/


# Update: 2008-02-21 We’re looking into using ActiveMessaging and Amazon SQS to help with the workflow for background processing. Stay tuned for an updated post.
# 
# With before_save and after_save filters being so easy to use, it’s tempting to add more and more pre and post-processing to saving an ActiveRecord model. For Obsidian Portal, we update permissions, set timestamps of associated objects, and do all sorts of stuff. Unfortunately, all this extra work takes time, and can significantly slow down your application. The more work you do on the main execution thread, the more time Mongrel is tied up doing stuff unrelated to servicing requests. If something goes wrong in any of the filters, Rails will rollback the database transaction, and *poof* it’s all gone!
# 
# A while back, we started seeing ‘rbuf_fill’ timeout errors in the server logs. From what we could see, calls to acts_as_solr indexing were timing out, interrupting the save. For us, this was really bad. People would spend lots of time painstakingly crafting their perfect blog posting or wiki page, only to have it evaporate into nothing. All they saw was our default "Internal Server Error" page. Sure, it looks nice, but no one wants to see that ;)
# 
# Tracing the timeout back to Solr was not hard, and the solution was clear: take the indexing out of the main execution thread and move it to a background process. Luckily, acts_as_solr made this a fairly easy refactoring process. Here’s what we did:
# Add an :if clause to your acts_as_solr macro call
# 
# acts_as_solr supports an :if clause that will be used to determine whether or not the record will be indexed when save is called. We want this to always evaluate to false, except when we explicitly set it to true during off-line processing. Below is an example from one of our models:
# 
# acts_as_solr :fields => [:name, :body, :post_title, :post_tagline, :slug],
# :if => :solr_index?
# 
# def solr_index?
# @solr_index
# end
# attr_writer :solr_index
# Use rake/cron to do the indexing in the background.
# 
# Now that indexing does not happen on save, we need to make sure it happens at some point. Our solution was to move it to a rake task that gets executed by a periodic cron job. Rake + cron has worked well for us in the past, so we’ll stick with it.
# 
# The task itself is very simple. Find all the objects that have been updated since the last indexing, 
# and push them to Solr.
# 
# Below is the rake task that I wrote. If I were more clever, I would probably come up with a neat trick for automatically finding all the models that support Solr indexing. Now that I’m an official committer on acts_as_solr, maybe I’ll try to figure something out and get it into the trunk. Still…I’m lazy :)

# sudo rake solr:index:users
    
# namespace :solr do
#   
#   namespace :index do
#     
#     desc "Indexes groups"
#     task :groups => :environment do
#       index_class(Group)
#     end
# 
#     desc "Indexes schedules"
#     task :schedules => :environment do
#       index_class(Schedule)
#     end
# 
#     desc "Indexes tournaments"
#     task :tournaments => :environment do
#       index_class(Tournament)
#     end
# 
#     desc "Indexes users"
#     task :users => :environment do
#       index_class(User)
#     end
# 
#     desc "Indexes everything that we’re storing in solr"
#     task :all => [:groups, :schedules, :tournaments, :users]
# 
#     def index_class(klass)
#       # If REBUILD is set to "true" then we rebuild the entire index
#       rebuild = ENV["REBUILD"] ? ENV["REBUILD"] == "true" : false
# 
#       interval = rebuild ? 100.years : 30.minutes
# 
#       objects = klass.find(:all, :conditions => ["updated_at > ? and archive = false", (Time.zone.now - 100.days) - interval]) #,    :page => {:size => 20, :auto => true}     )
# 
#       objects.each do |o|
#         puts("Indexing #{klass.to_s}: #{o.id}")
#         o.solr_index = true
#         o.solr_save
#       end
#       # klass.solr_optimize
# 
#     end
#   end
# end

# Set up a cron job to run this every thirty minutes or so. For most sites, a half hour will be a good balance between keeping the load down and making sure the searching is fairly up to date.
# 
# By moving the indexing off the main thread, we’ve noticed a significant reduction in the number of Solr related exceptions. That means our users have seen a significant reduction in the number of "Sorry, we lost all your data" errors, and that is exactly what we were hoping for.
# References
# 
#     * Solr homepage
#     * acts_as_solr Trac instance
#     * ActiveMessaging in Rails
#     * Obsidian Portal – Create your own D&D campaign website!
# 
# 11 Responses to "Optimizing Solr and Rails – Index in the background"
# 
#    1. Nima Negahban Says:
#       January 26th, 2008 at 5:25 pm
# 
#       Take a look at sphinx , I know you may be heavily invested in Solr but sphinx really kicks ass , and indexes in lightning speed, with high stability. Also as you guys grow have you guys thought about using active_messaging and something like apache mq, for the more complex back-end tasks it comes in handy.
#    2. Micah Says:
#       January 27th, 2008 at 9:01 pm
# 
#       Hi Nima,
# 
#       I’ve never heard of sphinx. I’ll have to take a closer look sometime.
# 
#       As to the active_messaging, that’s also new to me. We’ve been using rake + cron, and while it works, it seems a little ungainly. So, if there’s a better way to do it (that’s not a total pain to get working), then I’m all over that.
#    3. Nazar Says:
#       February 1st, 2008 at 3:38 am
# 
#       Check out backgroundDRB if you need to run one off or scheduled background tasks. It offers a far more elegant solution compared to rake + cron.
#    4. Jacob Stetser Says:
#       February 2nd, 2008 at 3:21 pm
# 
#       We had the same issue with solr, and also traced it to acts_as_solr committing after every request. Eventually, we figured out the same thing – stop committing every save. Then the problem became – newer stuff was not showing up in the index, until we figured out we needed to send a commit command every so often!
# 
#       The newer versions of Solr also support autocommitting by time elapsed or number of documents uncommitted, so now we let Solr handle its own reindexing.
# 
#       That solved a lot of our issues, but we’ve also moved to ActiveMQ and ActiveMessaging to offload the process of sending updates to the index. Each update goes into an indexing queue and then a separate processor (written in ruby with active_messaging) grabs from the queue and ships it off to Solr.
# 
#       Since then, we’ve had much faster saves, up-to-date indexing and no save timeouts – even if the Solr service was offline. When we restart it, the processors resume where they left off.
# 
#       Once you get to this point, being able to offload stuff that doesn’t need to happen in the space of a web request is vital to performance. The hardest part of ActiveMessaging with ActiveMQ is getting ActiveMQ running (java!!!) – but there are extremely simple-to-use ruby message queuing solutions around. The main idea is to move to a message queue architecture where you rapidly hand off the work request (update Solr with this record) to a queue, instead of slowly wait for Solr to respond and possibly lose the input because of a timeout error.
# 
#       As far as backgroundRB, I wouldn’t recommend using it at this point – ActiveMessaging or ‘bj’ are much newer and more reliable, and the author of bdrb has publicly recommended against using it any more.
#    5. Micah Says:
#       February 4th, 2008 at 6:04 am
# 
#       Jacob,
# 
#       Thanks. This is all great stuff. I’ll have to look into ActiveMessaging, as the rake + cron solution is workable, but seems inelegant.
# 
#       This might actually solve another problem we’re looking at: capturing deletes. Currently, deletes from Solr still take place in the web request, because once they’re gone from the database, we have no way to figure out what exactly was deleted. From your post, it sounds like we could use ActiveMessaging to handle this.
#    6. Alex Payne Says:
#       February 4th, 2008 at 5:02 pm
# 
#       We use Solr for our "people search" feature at Twitter. We use acts_as_modified to determine whether or not an ActiveRecord object has changed and thus should be updated in the Solr index. Our Starling queue server stores the list of objects that need to be re-indexed. A simple daemon reads from that queue and fires off messages to Solr. Two cron jobs periodically commit and optimize the index.
#    7. Micah Says:
#       February 5th, 2008 at 6:28 am
# 
#       I may have to write a follow up to this article covering the use of message queue servers. That seems to be a common theme with Solr.
# 
#       On that note, what is the memory usage like for ActiveMQ? Our VPS is already swapping like mad thanks to Solr and RMagick. We may have to disable search entirely just to make sure that MySQL doesn’t have to swap to disk all the time. From a few mailing list posts I’ve read, ActiveMQ (like most things Java) is not shy about grabbing memory, which is a big no-no for those of us trying to squeeze everything in a limited size.
# 
#       Which message server has the absolute smallest memory footprint? That means more to me than fancy features.
#    8. Geoff Says:
#       March 1st, 2008 at 10:23 am
# 
#       preventing solr from indexing on every save is a good practice. But I suspect that the solr has even deeper problems after reading this:
# 
#       http://headius.blogspot.com/2008/02/rubys-threadraise-threadkill-timeoutrb.html
#    9. Midnight Oil » Blog Archive » Hacking the Ultrasphinx plugin to work with paginating_find Says:
#       April 19th, 2008 at 2:59 pm
# 
#       [...] Getting started with acts_as_solr acts_as_solr for development and production in one Tomcat instance Optimizing Solr and Rails – Index in the background [...]
#   10. shokal_s Says:
#       August 5th, 2008 at 11:56 pm
# 
#       Modifying the in the solrconfig.xml file from 10 (default value on installation) to 20 has made the index action 10 times faster for me (reduced from 30sec to 3sec), while the query time is not significantly slower.
#   11. shokal_s Says:
#       August 6th, 2008 at 12:13 am
# 
#       Modifying the mergeFactor in the solrconfig.xml from 10 (default on installation) to 20, made the solr index 10 times faster (3 sec instead of 30sec) and the query time wasn’t significantly higher.
# 
# Leave a Reply
# 
# Name (required)
# 
# Mail (will not be published) (required)
# 
# Website