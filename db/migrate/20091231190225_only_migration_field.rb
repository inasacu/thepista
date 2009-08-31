class OnlyMigrationField < ActiveRecord::Migration
  def self.up
    
    # rake db:migrate VERSION=20090830181157
    
    # add_column    :messages,  :sender_read,                   :string
    # add_column    :messages,  :recipient_read,                :string
    # add_column    :messages,  :user_id,                       :string
    # add_column    :messages,  :to_user_id,                    :string
    # add_column    :messages,  :to_group_id,                   :string
    # add_column    :messages,  :re_message_id,                 :string
    # add_column    :messages,  :user_read,                     :string
    # add_column    :messages,  :to_user_read,                  :string
    # add_column    :messages,  :to_group_read,                 :string
    # add_column    :messages,  :user_archive,                  :string
    # add_column    :messages,  :to_user_archive,               :string
    # add_column    :messages,  :to_group_archive,              :string  
    # 
    # add_column    :groups,    :reliable,                      :string  
    # add_column    :groups,    :default_available,             :string  
    # add_column    :groups,    :default_reliable,              :string  
    # add_column    :groups,    :domain,                        :string  
    # add_column    :groups,    :activity_id,                   :string  
    # add_column    :groups,    :address_id,                    :string  
    # 
    # add_column    :users,     :nickname,                      :string  
    # add_column    :users,     :default_email,                 :string  
    # add_column    :users,     :default_available,             :string  
    # add_column    :users,     :default_reliable,              :string  
    # add_column    :users,     :remember_token,                :string  
    # add_column    :users,     :remember_token_expires_at,     :string  
    # add_column    :users,     :salt,                          :string  
    # add_column    :users,     :beta_code,                     :string  
    # add_column    :users,     :invitation_id,                 :string  
    # add_column    :users,     :invitation_limit,              :string  
    # add_column    :users,     :terms,                         :string  
    # add_column    :users,     :contract_ends_at,              :string  
    # add_column    :users,     :conditions,                    :string  
    # add_column    :users,     :has_gravatar,                  :string  
    # add_column    :users,     :reliable,                      :string  
    # add_column    :users,     :injury,                        :string  
    # add_column    :users,     :private_email,                 :string  
    # add_column    :users,     :interest,                      :string  
    # add_column    :users,     :default_avatar,                :string  
    # add_column    :users,     :provider,                      :string  
    # add_column    :users,     :openid_login,                  :string  
    # add_column    :users,     :last_logged_at,                :string  
    # add_column    :users,     :status,                        :string  
    # add_column    :users,     :available_starts_at,           :string  
    # add_column    :users,     :available_ends_at,             :string  
    # add_column    :users,     :injury_until,                  :string
    # 
    # add_column    :fees,       :match_id,                     :string
    # add_column    :fees,       :actual_fee,                   :string
    # add_column    :fees,       :table_id,                     :string
    # add_column    :fees,       :table_type,                   :string
    # 
    # add_column    :matches,     :reliable,                    :string
    # 
    # add_column    :schedules,   :invite_id,                   :string
    # add_column    :schedules,   :activity_id,                 :string
    
  end

  def self.down
    # remove_column    :messages,  :sender_read
    # remove_column    :messages,  :recipient_read
    # remove_column    :messages,  :user_id
    # remove_column    :messages,  :to_user_id
    # remove_column    :messages,  :to_group_id
    # remove_column    :messages,  :re_message_id
    # remove_column    :messages,  :user_read
    # remove_column    :messages,  :to_user_read
    # remove_column    :messages,  :to_group_read
    # remove_column    :messages,  :user_archive
    # remove_column    :messages,  :to_user_archive
    # remove_column    :messages,  :to_group_archive
    # 
    # remove_column      :groups,     :reliable 
    # remove_column      :groups,     :default_available
    # remove_column      :groups,     :default_reliable
    # remove_column      :groups,     :domain
    # remove_column      :groups,     :activity_id
    # remove_column      :groups,     :address_id
    # 
    # remove_column      :users,     :nickname
    # remove_column      :users,     :default_email
    # remove_column      :users,     :default_available
    # remove_column      :users,     :default_reliable
    # remove_column      :users,     :remember_token
    # remove_column      :users,     :remember_token_expires_at
    # remove_column      :users,     :salt
    # remove_column      :users,     :beta_code
    # remove_column      :users,     :invitation_id
    # remove_column      :users,     :invitation_limit
    # remove_column      :users,     :terms
    # remove_column      :users,     :contract_ends_at
    # remove_column      :users,     :conditions
    # remove_column      :users,     :has_gravatar
    # remove_column      :users,     :reliable
    # remove_column      :users,     :injury
    # remove_column      :users,     :private_email  
    # remove_column      :users,     :interest
    # remove_column      :users,     :default_avatar 
    # remove_column      :users,     :provider 
    # remove_column      :users,     :openid_login
    # remove_column      :users,     :last_logged_at
    # remove_column      :users,     :status
    # remove_column      :users,     :available_starts_at 
    # remove_column      :users,     :available_ends_at 
    # remove_column      :users,     :injury_until
    
    # remove_column      :fees,       :match_id
    # remove_column      :fees,       :actual_fee
    # remove_column      :fees,       :table_id
    # remove_column      :fees,       :table_type
    
    # remove_column      :matches,    :reliable
    # 
    # remove_column      :schedules,   :invite_id
    # remove_column      :schedules,   :activity_id
    
  end
end
