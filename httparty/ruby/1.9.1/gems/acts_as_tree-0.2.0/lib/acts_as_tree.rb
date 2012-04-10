require 'acts_as_tree/active_record/acts/tree'
require 'acts_as_tree/version'
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::Tree }
