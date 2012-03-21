class CupsEscuadras < ActiveRecord::Base

  self.primary_keys :escuadra_id, :cup_id 
  
  # record a cup join
  def self.join_escuadra(escuadra, cup)
    self.create!(:cup_id => cup.id, :escuadra_id => escuadra.id, :created_at => Time.now, :updated_at => Time.now) if self.exists?(escuadra, cup)
  end  

  def self.leave_escuadra(escuadra, cup) 
    connection.delete("DELETE FROM cups_escuadras WHERE cup_id = #{cup.id} and escuadra_id = #{escuadra.id} ")
  end

  # Return true if the escuadra cup nil
  def self.exists?(escuadra, cup)
    find_by_cup_id_and_escuadra_id(cup, escuadra).nil?
  end

end