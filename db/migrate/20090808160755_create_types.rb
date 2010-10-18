class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
        t.string      :name,          :limit => 40
        t.string      :table_type,    :limit => 40
        t.integer     :table_id

        t.timestamps
      end    

      # [[161,'convocado','Match'], [162,'ultima_hora','Match'], [163,'ausente','Match'],
      #   [164,'No_Jugado','Match'], [165,'Ultima_Hora','Match'], [166,'Tierra_roja','Marker'],
      #   [167,'Tierra','Marker'], [168,'Cemento','Marker'],  [169,'Parque','Marker'],
      #   [170,'cesped artificial'], [171,'cesped','Marker'], [172,'User','Payment'],
      #   [173,'Group','Payment'], [174,'Venue','Payment'], [175,'Store','Payment'],
      #   [176,'Therapist','Payment']].each do |type|
      #     Type.create(:id => type[0], :name => type[1], :table_type => type[2])
          
          # update types set name = 'ultima_hora' where id = 2
          # update types set name = 'convocado' where id = 1
          # update types set name = 'ausente' where id = 3
          # update types set name = 'no_jugado' where id = 4
      end
  end

  def self.down
    drop_table :types
  end
end
