class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      
      t.string    :name
      t.string    :email
      
      t.string    :openid_identifier
      t.string    :identity_url
      t.string    :language
      t.string    :country
      t.string    :time_zone,                      :default => 'UTC'
      t.string    :phone
      t.string    :position
      t.string    :dorsal
      t.integer   :technical
      t.integer   :physical
      
      t.string    :login,                         :default => nil,      :null => true

      t.integer   :rpxnow_id
      
      t.integer   :posts_count,                   :null => false,       :default => 0
      t.integer   :entries_count,                 :null => false,       :default => 0
      t.integer   :comments_count,                :null => false,       :default => 0
      t.string    :blog_title        
      
      t.boolean   :enable_comments,               :default => true
      t.boolean   :teammate_notification,         :default => true
      t.boolean   :message_notification,          :default => true     
      t.boolean   :blog_comment_notification,     :default => true
      t.boolean   :forum_comment_notification,    :default => true
 
      t.string    :photo_file_name
      t.string    :photo_content_type
      t.integer   :photo_file_size
      t.datetime  :photo_updated_at
      
      t.string    :crypted_password,              :default => nil,      :null => true
      t.string    :password_salt,                 :default => nil,      :null => true
      
      t.string    :persistence_token,                                   :null => false
      t.integer   :login_count,                   :default => 0,        :null => false
      t.datetime  :last_request_at
      t.datetime  :last_login_at
      t.datetime  :current_login_at
      t.string    :last_login_ip
      t.string    :current_login_ip

      t.boolean   :default_email,               :default => true
      t.boolean   :default_available,           :default => true
      t.boolean   :private_phone,               :default => false
      t.boolean   :private_profile,             :default => false
      
      t.text      :description
      
      t.string    :gender
      t.datetime  :birth_at
      
      t.boolean   :archive,                      :default => false      
      t.datetime  :deleted_at
      t.timestamps
    end
    
    add_index :users, :login
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    add_index :users, :openid_identifier
  end

  def self.down
    drop_table :users
  end
end
