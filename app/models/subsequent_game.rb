class SubsequentGame < Game
  
  def home_id
    self.children[0].winner_id
  end
  def home
    self.children[0].winner
  end

  def away_id
    self.children[1].winner_id
  end
  def away
    self.children[1].winner
  end
  
end
