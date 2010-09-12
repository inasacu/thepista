module GamesHelper

  def team_roster_link(text, game = nil, html_options = nil)
    if game.nil?
      game = text
      text = game.concept
    elsif game.is_a?(Hash)
      html_options = game
      game = text
      text = game.concept
    end    
    link_to(h(text), team_roster_path(:id => game), html_options)
  end 

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



