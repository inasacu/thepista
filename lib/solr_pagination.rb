# By Henrik Nyh <http://henrik.nyh.se> 2007-06-18.
# Free to modify and redistribute with credit.
# Adds a find_all_by_solr method to acts_as_solr models to enable 
# will_paginate for acts_as_solr search results.
# http://henrik.nyh.se/2007/06/using-will_paginate-with-acts_as_solr

#adds find_all_by_solr method to acts as solr models to enable
#will paginate support for acts_as_solr search results
module ActsAsSolr
 module PaginationExtension

   #performs the count solr needs behind the scenes.
   #done so you don't have to pass in the count manually.
   def wp_count(options, query, method)
     method =~ /_solr$/ ? count_by_solr(query.first, options) : super
   end

   def find_all_by_solr(*args)
     find_by_solr(*args).records
   end

 end
end

module ActsAsSolr::ClassMethods
  include ActsAsSolr::PaginationExtension
end



