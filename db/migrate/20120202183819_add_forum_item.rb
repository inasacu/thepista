class AddForumItem < ActiveRecord::Migration
  def self.up
    add_column        :forums,     :item_id,      :integer
    add_column        :forums,     :item_type,    :string
    
    add_index         :forums,      [:item_id, :item_type]
  end

  def self.down
  end
end
