class CreateCupsSquads < ActiveRecord::Migration
  def self.up
    create_table :cups_squads do |t|
       t.integer     :cup_id
       t.integer     :squad_id      
       t.datetime    :deleted_at
       t.timestamps
    end
  end

  def self.down
    drop_table :cups_squads
  end
end
