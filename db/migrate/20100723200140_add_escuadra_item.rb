class AddEscuadraItem < ActiveRecord::Migration
    def self.up
      add_column        :escuadras,           :item_id,            :integer
      add_column        :escuadras,           :item_type,          :string
      
      # update current escuadras to escuadras...these are used for official games only
      sql = %(UPDATE escuadras set item_id = id, item_type = 'Escuadra' where item_id is null and item_type is null)
      ActiveRecord::Base.connection.execute(sql)     

      # unarchive all archived matches
      sql = %(UPDATE matches set archive = false where group_id = 1 and archive = true)
      ActiveRecord::Base.connection.execute(sql)
      
      # unarchive all archived scorecards
      sql = %(UPDATE scorecards set archive = false where group_id = 1 and archive = true)
      ActiveRecord::Base.connection.execute(sql)
       
    end

    def self.down
      remove_column     :escuadras,           :item_id
      remove_column     :escuadras,           :item_type
    end
  end
