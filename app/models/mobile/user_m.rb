class Mobile::UserM
  
  attr_accessor :legacy_id, :name, :email, :phone, :is_whatsapp_phone, :city, :language

  # MOBILE --------------------------

  def initialize(user=nil)
    if !user.nil?
      @legacy_id = user.id
      @name = user.name
      @email = user.email
      @phone = user.phone
      @is_whatsapp_phone = user.whatsapp
      if user.city
        @city = {:id => user.city.id, :name => user.city.name}
      end
      @language = user.language
    end
  end

  def self.build_from_users(users_list)
    new_user_list = []
    if users_list
      users_list.each do |u|
        new_user_list << self.new(u)
      end
    end
    return new_user_list
  end
    
  def self.user_registration(user_map=nil)
    if user_map

      new_user = User.new
      begin
        User.transaction do
          new_user.email = user_map[:user_email]
          new_user.name = user_map[:user_name].nil? ? user_map[:user_email] : user_map[:user_name]
          new_user.email_to_name if new_user.name.include?('@')
          new_user.phone = user_map[:user_phone]
          new_user.whatsapp = (user_map[:user_use_wa]=="1")
          new_user.city_id = user_map[:user_city]
          new_user.email_backup = new_user.email
          new_user.language = "es" if user_map[:user_language].nil?
          # dummy passsword because oauth is used always
          new_user.password = user_map[:user_email]
          new_user.password_confirmation = user_map[:user_email]

          # Identifies the provider profile for this user
          new_user.identity_url = user_map[:user_identity_url]
          
          # Sets corresponding confirmation info
          no_confirmation_needed = DISABLE_PROVIDER_EMAIL.include?(new_user.identity_url)
          if no_confirmation_needed
            new_user.confirmation
          else
            new_user.set_confirmation_token
          end

          # Signup mail with confirmation link is sent after creation
          if new_user.save!
            # Success in creation of record in user table - authentications table record next
            omniauth = Hash.new
            omniauth["uid"] = user_map[:user_uid]
            omniauth["provider"] = user_map[:user_provider]
            Authentication.create_from_omniauth(omniauth, new_user)
          else
            # Error in creation of user
          end

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while signup #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        new_user = nil
      end

      return new_user
    else
      Rails.logger.debug "Null map for the user info"
      return nil
    end
  end

  def self.user_logout(user_id)
    return Mobile::MobileToken.deactivate_token(user_id)
  end

  def self.user_account_info(user_id)
    user = User.find(user_id)
    user_m = Mobile::UserM.new(user)
    return user_m
  end
  
end