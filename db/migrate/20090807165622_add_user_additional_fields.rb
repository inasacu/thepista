class AddUserAdditionalFields < ActiveRecord::Migration
  def self.up
    add_column     :users,     :identity_url,            :string  
    add_column     :users,     :language,                :string
    add_column     :users,     :country,                 :string
    add_column     :users,     :time_zone,               :string
    add_column     :users,     :phone,                   :string
    add_column     :users,     :position,                :string
    add_column     :users,     :dorsal,                  :string
    add_column     :users,     :technical,               :integer
    add_column     :users,     :physical,                :integer

    add_column     :users,     :default_email,           :boolean,         :default => true
    add_column     :users,     :default_available,       :boolean,         :default => true

    add_column     :users,     :private_phone,           :boolean,         :default => false
    add_column     :users,     :private_profile,         :boolean,         :default => false
    add_column     :users,     :description,             :text
    add_column     :users,     :gender,                  :string
    add_column     :users,     :birth_at,                :datetime
    add_column     :users,     :archive,                 :boolean,         :default => false
  end

  def self.down
      remove_column     :users,     :identity_url,            :string  
      remove_column     :users,     :language,                :string
      remove_column     :users,     :country,                 :string
      remove_column     :users,     :time_zone,               :string
      remove_column     :users,     :phone,                   :string
      remove_column     :users,     :position,                :string
      remove_column     :users,     :dorsal,                  :string
      remove_column     :users,     :technical,               :integer
      remove_column     :users,     :physical,                :integer

      remove_column     :users,     :default_email,           :boolean,         :default => true
      remove_column     :users,     :default_available,       :boolean,         :default => true

      remove_column     :users,     :private_phone,           :boolean,         :default => false
      remove_column     :users,     :private_profile,         :boolean,         :default => false
      remove_column     :users,     :description,             :text
      remove_column     :users,     :gender,                  :string
      remove_column     :users,     :birth_at,                :datetime
      remove_column     :users,     :archive,                 :boolean,         :default => false
    end
end

