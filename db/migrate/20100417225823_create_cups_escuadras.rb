class CreateCupsEscuadras < ActiveRecord::Migration
  def self.up
    drop_table :cups_escuadras
    create_table :cups_escuadras, :id => false, :force => true  do |t|
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
