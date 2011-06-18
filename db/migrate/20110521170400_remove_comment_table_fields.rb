class RemoveCommentTableFields < ActiveRecord::Migration
  def self.up    
    add_column        :matches,       :block_token,   :string  
  end

  def self.down    
    remove_column     :matches,       :block_token
  end
end
