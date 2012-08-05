class AdditionalTournamentFields < ActiveRecord::Migration
  def self.up
		drop_table		:comments
		# drop_table		:rates
		drop_table 		:blogs
		drop_table 		:forums
		drop_table		:slugs 
		drop_table 		:classifieds
		# drop_table 		:taggings
		# drop_table 		:tags
  end

  def self.down
  end
end
