class PrePurchase < ActiveRecord::Base
  
  
  belongs_to  :item,            :polymorphic => true
  belongs_to  :installation
  
  def self.pre_purchase_available(installation, block_token, item)
      find(:first, :conditions =>["installation_id = ? and block_token = ? and item_id = ? and item_type = ?", installation, block_token, item.id, item.class.to_s]).nil?
  end
  
end
