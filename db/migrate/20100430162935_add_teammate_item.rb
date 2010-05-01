class AddTeammateItem < ActiveRecord::Migration
    def self.up
      add_column        :teammates,           :item_id,            :integer
      add_column        :teammates,           :item_type,          :string
    end

    def self.down
      remove_column     :teammates,           :item_id
      remove_column     :teammates,           :item_type
    end
  end
