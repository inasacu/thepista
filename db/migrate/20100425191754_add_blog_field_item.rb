class AddBlogFieldItem < ActiveRecord::Migration
  def self.up
    add_column        :blogs,           :item_id,       :integer
    add_column        :blogs,           :item_type,     :string
  end

  def self.down
  end
end
