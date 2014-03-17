class Mobile::GroupM
  
  attr_accessor :legacy_id, :name, :second_team, :sport_id, :sport_desc, :conditions, :number_of_members
  
  def initialize(group=nil)
    if !group.nil?
      @legacy_id = group.id
      @name = group.name
      @second_team = group.second_team
      @sport_id = group.sport.id
      @sport_desc = group.sport.name
      @conditions = group.conditions
      @number_of_members = group.users.size
    end
  end
  
end