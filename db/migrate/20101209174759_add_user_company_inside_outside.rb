class AddUserCompanyInsideOutside < ActiveRecord::Migration
  def self.up
    add_column        :users,       :company_url,         :string
    add_column        :users,       :company_inside,      :boolean,     :default => false
    add_column        :users,       :company_outside,     :boolean,     :default => false
    # add_column        :users,       :company_starts_at,   :datetime
  end

  def self.down
    remove_column     :users,       :company_url
    remove_column     :users,       :company_inside
    remove_column     :users,       :company_outside
    # remove_column     :users,       :company_starts_at
  end
end
