class CupsSquads < ActiveRecord::Base

  set_primary_keys :squad_id, :cup_id 
  
  # record a cup join
  def self.join_squad(squad, cup)
    self.create!(:cup_id => cup.id, :squad_id => squad.id) if self.exists?(squad, cup)
  end  

  def self.leave_squad(squad, cup) 
    connection.delete("DELETE FROM cups_squads WHERE cup_id = #{cup.id} and squad_id = #{squad.id} ")
  end

  # Return true if the squad cup nil
  def self.exists?(squad, cup)
    find_by_cup_id_and_squad_id(cup, squad).nil?
  end

end