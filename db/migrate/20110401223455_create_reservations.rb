class CreateReservations < ActiveRecord::Migration
  def self.up

    create_table :reservations do |t|
      t.string        :concept

      t.datetime      :starts_at
      t.datetime      :ends_at
      t.datetime      :reminder_at

      t.integer       :venue_id
      t.integer       :installation_id

      t.integer       :item_id
      t.string        :item_type

      t.float         :fee_per_game,        :default => 0.0
      t.float         :fee_per_lighting,    :default => 0.0

      t.boolean       :available,           :default => true
      t.boolean       :reminder,            :default => true
      t.boolean       :public,              :default => true

      t.text          :description
      t.string        :block_token
      t.boolean       :archive,             :default => false

      t.timestamps
    end    
    add_index     :reservations,      :venue_id
    add_index     :reservations,      :installation_id  
    add_index     :reservations,      [:item_id, :item_type]

    # rake db:migrate VERSION=20110401223423
    # rake db:migrate

  end

  def self.down
    drop_table :reservations
  end
end
