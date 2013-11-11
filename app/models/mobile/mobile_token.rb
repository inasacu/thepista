class Mobile::MobileToken
    
  include Mongoid::Document
  store_in collection: "mobileTokens"
  
  field :legacy_id, type: Integer
  field :token, type: String
  field :name, type: String
  field :email, type: String
  field :generated_time, type: DateTime, default: DateTime.now
  field :active, type: Integer, default: 0
  
  validates_presence_of :legacy_id
  validates_presence_of :token
  validates_presence_of :email
  validates_presence_of :generated_time
  validates_inclusion_of :active, in: [ 0, 1 ]
  
  def self.generate_token_string
    token = nil
    token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.where(token: random_token).exists?
    end
    return token
  end
  
  def self.get_token(id, email, name)
    # Deactivate previous tokens for this user
    self.where(legacy_id: id).update_all(active: 0)
    
    # Get new token
    new_token = self.create!(
      legacy_id: id,
      token: generate_token_string,
      name: name,
      email: email,
      generated_time: DateTime.now,
      active: 1
    )
    
    return new_token
  end
  
  def self.get_mock_token(omniauth)
    mobile_token = self.new
    mobile_token.email = omniauth['info']['email'] if omniauth['info']['email']
    
	  mobile_token.name = omniauth['info']['name'] if omniauth['info']['name']
	  mobile_token.name = token.email if token.name.nil?
    mobile_token.email_to_name if token.name.include?('@')
    
    mobile_token.legacy_id = 0
    mobile_token.generated_time = DateTime.now
    mobile_token.active = 0
    
    return token
  end
  
  # copied from user model
  def email_to_name
    self.name = self.email[/[^@]+/]
    self.name.split(".").map {|n| n.capitalize }.join(" ")
  end
  
end