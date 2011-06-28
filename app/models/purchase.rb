class Purchase < ActiveRecord::Base

  include TokenGenerator

  # variables to access
  # attr_accessible :installation_id, :token, :updated_at, :transaction_id, :amount, :avs_code, :item_id, :block_token, :cvv2_code, :item_type

  def to_param
    self.token
  end

  def response=(info)
    # CC Response
    %w(cvv2_code avs_code amount transaction_id).each do |f|
      self.send("#{f}=", info.params[f])
    end
    # Express Checkout Response
    self.amount = info.params['gross_amount'] if info.params['gross_amount']
  end
end
