class CreateRates < ActiveRecord::Migration
  def self.up
		drop_table 		:blogs
		drop_table 		:forums
		drop_table		:slugs 
		drop_table 		:classifieds
  end

  def self.down
  end
end
