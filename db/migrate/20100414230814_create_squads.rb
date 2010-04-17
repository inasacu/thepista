class CreateSquads < ActiveRecord::Migration
  def self.up
    create_table :squads do |t|

      t.string      :name
      t.text        :description
      
      t.string      :photo_file_name
      t.string      :photo_content_type
      t.integer     :photo_file_size
      t.datetime    :photo_updated_at

      # t.string      :flag_file_name
      # t.string      :flag_content_type
      # t.integer     :flag_file_size
      # t.datetime    :flag_updated_at
      
      t.boolean     :archive,               :default => false
      t.datetime    :deleted_at
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :squads
  end
end
