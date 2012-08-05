class AddMessagePolimorphValues < ActiveRecord::Migration
  def self.up
    add_column      :messages,    :item_id,       :integer
    add_column      :messages,    :item_type,     :string
    
    add_index       :messages,    [:item_id,    :item_type]
  end

  def self.down
  end
end
