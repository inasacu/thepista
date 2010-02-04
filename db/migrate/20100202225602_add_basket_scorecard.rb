class AddBasketScorecard < ActiveRecord::Migration
  def self.up    
    # # basketball stats per match
    add_column    :matches,      :field_goal_attempt,       :integer,     :default => 0
    add_column    :matches,      :field_goal_made,           :integer,     :default => 0
    add_column    :matches,      :free_throw_attempt,       :integer,     :default => 0
    add_column    :matches,      :free_throw_made,           :integer,     :default => 0
    add_column    :matches,      :three_point_attempt,      :integer,     :default => 0
    add_column    :matches,      :three_point_made,          :integer,     :default => 0
    add_column    :matches,      :rebounds,                   :integer,     :default => 0
    add_column    :matches,      :rebounds_defense,           :integer,     :default => 0
    add_column    :matches,      :rebounds_offense,           :integer,     :default => 0    
    add_column    :matches,      :minutes_played,             :integer,     :default => 0

    add_column    :matches,      :assists,                    :integer,     :default => 0
    add_column    :matches,      :steals,                     :integer,     :default => 0
    add_column    :matches,      :blocks,                     :integer,     :default => 0
    add_column    :matches,      :turnovers,                  :integer,     :default => 0
    add_column    :matches,      :personal_fouls,             :integer,     :default => 0

    add_column    :matches,      :game_started,               :boolean,     :default => true

    # # basketball stats for scorcard
    add_column    :scorecards,   :field_goal_attempt,       :integer,     :default => 0
    add_column    :scorecards,   :field_goal_made,           :integer,     :default => 0
    add_column    :scorecards,   :free_throw_attempt,       :integer,     :default => 0
    add_column    :scorecards,   :free_throw_made,           :integer,     :default => 0
    add_column    :scorecards,   :three_point_attempt,      :integer,     :default => 0
    add_column    :scorecards,   :three_point_made,          :integer,     :default => 0
    add_column    :scorecards,   :rebound,                   :integer,     :default => 0
    add_column    :scorecards,   :rebound_defense,           :integer,     :default => 0
    add_column    :scorecards,   :rebound_offense,           :integer,     :default => 0    
    add_column    :scorecards,   :minutes_played,             :integer,     :default => 0

    add_column    :scorecards,   :assists,                    :integer,     :default => 0
    add_column    :scorecards,   :steals,                     :integer,     :default => 0
    add_column    :scorecards,   :blocks,                     :integer,     :default => 0
    add_column    :scorecards,   :turnovers,                  :integer,     :default => 0
    add_column    :scorecards,   :personal_fouls,             :integer,     :default => 0

    add_column    :scorecards,   :game_started,               :integer,     :default => 0

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
    remove_column    :matches,      :field_goal_attempt,       :integer,     :default => 0
    remove_column    :matches,      :field_goal_made,           :integer,     :default => 0
    remove_column    :matches,      :free_throw_attempt,       :integer,     :default => 0
    remove_column    :matches,      :free_throw_made,           :integer,     :default => 0
    remove_column    :matches,      :three_point_attempt,      :integer,     :default => 0
    remove_column    :matches,      :three_point_made,          :integer,     :default => 0
    remove_column    :matches,      :rebounds,                   :integer,     :default => 0
    remove_column    :matches,      :rebounds_defense,           :integer,     :default => 0
    remove_column    :matches,      :rebounds_offense,           :integer,     :default => 0    
    remove_column    :matches,      :minutes_played,             :integer,     :default => 0

    remove_column    :matches,      :assists,                    :integer,     :default => 0
    remove_column    :matches,      :steals,                     :integer,     :default => 0
    remove_column    :matches,      :blocks,                     :integer,     :default => 0
    remove_column    :matches,      :turnovers,                  :integer,     :default => 0
    remove_column    :matches,      :personal_fouls,             :integer,     :default => 0

    remove_column    :matches,      :game_started,               :boolean,     :default => true

    # # basketball stats for scorcard
    remove_column    :scorecards,   :field_goal_attempt,       :integer,     :default => 0
    remove_column    :scorecards,   :field_goal_made,           :integer,     :default => 0
    remove_column    :scorecards,   :free_throw_attempt,       :integer,     :default => 0
    remove_column    :scorecards,   :free_throw_made,           :integer,     :default => 0
    remove_column    :scorecards,   :three_point_attempt,      :integer,     :default => 0
    remove_column    :scorecards,   :three_point_made,          :integer,     :default => 0
    remove_column    :scorecards,   :rebound,                   :integer,     :default => 0
    remove_column    :scorecards,   :rebound_defense,           :integer,     :default => 0
    remove_column    :scorecards,   :rebound_offense,           :integer,     :default => 0    
    remove_column    :scorecards,   :minutes_played,             :integer,     :default => 0

    remove_column    :scorecards,   :assists,                    :integer,     :default => 0
    remove_column    :scorecards,   :steals,                     :integer,     :default => 0
    remove_column    :scorecards,   :blocks,                     :integer,     :default => 0
    remove_column    :scorecards,   :turnovers,                  :integer,     :default => 0
    remove_column    :scorecards,   :personal_fouls,             :integer,     :default => 0

    remove_column    :scorecards,   :game_started,               :integer,     :default => 0
  end
end
