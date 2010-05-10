class FirstGame < Game
  belongs_to :home,   :class_name => 'Escuadra',  :foreign_key => 'home_id' 
  belongs_to :away,   :class_name => 'Escuadra',  :foreign_key => 'away_id'
end