class AddBlogFieldItem < ActiveRecord::Migration
  def self.up
    add_column        :blogs,           :item_id,       :integer
    add_column        :blogs,           :item_type,     :string
  end

  def self.down
    remove_column     :blogs,           :item_id
    remove_column     :blogs,           :item_type
  end
end
