class AddGroupInstallationLinkedin < ActiveRecord::Migration
  def self.up
    add_column      :users,             :linkedin_url,              :string
    add_column      :users,             :linkedin_token,            :string
    add_column      :users,             :linkedin_secret,          :string
    add_column      :groups,            :installation_id,           :integer
  end

  def self.down
    remove_column   :users,             :linkedin_url
    remove_column   :users,             :linkedin_token
    remove_column   :users,             :linkedin_secret
    remove_column   :groups ,           :installation_id
  end
end
