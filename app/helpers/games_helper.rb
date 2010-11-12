module GamesHelper

  def game_image_link_small(game)
    link_to(image_tag(game.cup.sport.icon, options={:style => "height: 15px; width: 15px;"}), game_path(game))
  end    

  def game_image_small(game)
    image_tag(game.cup.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end

  def game_score_link(game)
    return "  #{game.home_score}  -  #{game.away_score}  " 
  end
  
end



