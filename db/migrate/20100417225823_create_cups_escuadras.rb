class CreateCupsEscuadras < ActiveRecord::Migration
  def self.up
    create_table :cups_escuadras do |t|
       t.integer     :cup_id
       t.integer     :escuadra_id      
       t.datetime    :deleted_at
       t.timestamps
    end
  end

  def self.down
    drop_table :cups_escuadras
  end
end
