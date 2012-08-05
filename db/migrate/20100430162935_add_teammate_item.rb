class AddTeammateItem < ActiveRecord::Migration
	def self.up
		add_column        :teammates,           :item_id,            :integer
		add_column        :teammates,           :item_type,          :string
	end

	def self.down
	end
end
