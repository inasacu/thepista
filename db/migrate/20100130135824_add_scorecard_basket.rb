class AddScorecardBasket < ActiveRecord::Migration
  def self.up
    
    # # basketball stats per match
    # add_column    :matches,      :field_goals_attemped,      :integer,     :default => 0
    # add_column    :matches,      :field_goals_made,          :integer,     :default => 0
    # add_column    :matches,      :free_throws_attemped,      :integer,     :default => 0
    # add_column    :matches,      :free_throws_made,          :integer,     :default => 0
    # add_column    :matches,      :three_points_attemped,     :integer,     :default => 0
    # add_column    :matches,      :three_points_made,         :integer,     :default => 0
    # add_column    :matches,      :rebounds,                  :integer,     :default => 0
    # add_column    :matches,      :rebounds_defense,          :integer,     :default => 0
    # add_column    :matches,      :rebounds_offense,          :integer,     :default => 0    
    # add_column    :matches,      :minutes_played,            :integer,     :default => 0
    # add_column    :matches,      :game_started,              :boolean,     :default => true
    # 
    # # basketball stats for scorcard
    # add_column    :scorecards,   :field_goals_attemped,      :integer,     :default => 0
    # add_column    :scorecards,   :field_goals_made,          :integer,     :default => 0
    # add_column    :scorecards,   :free_throws_attemped,      :integer,     :default => 0
    # add_column    :scorecards,   :free_throws_made,          :integer,     :default => 0
    # add_column    :scorecards,   :three_points_attemped,     :integer,     :default => 0
    # add_column    :scorecards,   :three_points_made,         :integer,     :default => 0
    # add_column    :scorecards,   :rebounds,                  :integer,     :default => 0
    # add_column    :scorecards,   :rebounds_defense,          :integer,     :default => 0
    # add_column    :scorecards,   :rebounds_offense,          :integer,     :default => 0    
    # add_column    :scorecards,   :minutes_played,            :integer,     :default => 0
    # add_column    :scorecards,   :game_started,              :integer,     :default => 0
        
    # Some statistics are
    # GP, GS: games played, games started
    # PTS: points
    # FGM, FGA, FG%: field goals made, attempted and percentage
    # FTM, FTA, FT%: free throws made, attempted and percentage
    # 3FGM, 3FGA, 3FG%: three-point field goals made, attempted and percentage
    # REB, OREB, DREB: rebounds, offensive rebounds, defensive rebounds
    # AST: assists
    # STL: steals
    # BLK: blocks
    # TO: turnovers
    # PF: personal fouls
    # MIN: minutes
    # AST/TO: assist to turnover ratio
    
    # Tiros Libres (1 punto) tirados
    # Tiros Libres (1 punto) convertidos
    # %  acierto en tiros libres
    # Tiros Libres (2 puntos) tirados
    # Tiros Libres (2 puntos) convertidos
    # %  acierto en tiros de 2 puntos
    # Tiros Libres (3 puntos) tirados
    # Tiros Libres (3 puntos) convertidos
    # %  acierto en tiros de 3 puntos
    # Rebotes ofensivos
    # Rebotes defensivos
    # Minutos jugados
    
  end

  def self.down
  end
end
