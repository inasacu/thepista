module SportsHelper

  def sport_list(objects)
    list_of_objects = ""
    
    @all_sports = []
    objects.each do |object|

      unless @all_sports.include?(object.sport_id)
        @all_sports << object.sport_id 
        list_of_objects += "#{object.sport.name}, "  
      end  
        
    end
    return list_of_objects.chop.chop
  end
end

