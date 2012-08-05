class CreateEscuadras < ActiveRecord::Migration
  def self.up
    create_table :escuadras do |t|

      t.string      :name
      t.text        :description
      
      t.string      :photo_file_name
      t.string      :photo_content_type
      t.integer     :photo_file_size
      t.datetime    :photo_updated_at
      
      t.boolean     :archive,               :default => false
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
