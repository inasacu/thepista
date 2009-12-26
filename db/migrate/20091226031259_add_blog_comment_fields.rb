class AddBlogCommentFields < ActiveRecord::Migration
  def self.up
    add_column        :comments,      :title,                 :string,        :limit => 50,           :default => "" 
    change_column     :comments,      :body,                  :text,                                  :default => ""
    add_column        :comments,      :commentable_type,      :string
    add_column        :comments,      :commentable_id,        :integer
    
    add_index         :comments,      :commentable_type
    add_index         :comments,      :commentable_id
    add_index         :comments,      :user_id
  end

  def self.down
    remove_column     :comments,      :title
    remove_column     :comments,      :commentable_type
    remove_column     :comments,      :commentable_id
  end
end
