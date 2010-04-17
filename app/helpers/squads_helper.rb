module SquadsHelper

  # Link to a squad (default is by name).
  def squad_link(text, squad = nil, html_options = nil)
    if squad.nil?
      squad = text
      text = squad.name
    elsif squad.is_a?(Hash)
      html_options = squad
      squad = text
      text = squad.name
    end
    # We normally write link_to(..., squad) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), squad, html_options)
  end

  def squad_show_photo(squad, current_user)
    if squad.photo_file_name
      # return image_tag(squad.photo.url)
      return squad_image_link_large(squad)
    end
    if current_user.is_manager_of?(squad)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_squad_path(squad))}"
    else  
      return squad_image_link_large(squad)
    end
  end

  def squad_image_link_tiny(squad)
    link_to(image_tag(squad.avatar, options={:style => "height: 15px; width: 15px;"}), squad_path(squad)) 
  end

  def squad_image_link_smaller(squad)
    link_to(image_tag(squad.avatar, options={:style => "height: 22px; width: 22px;"}), squad_path(squad)) 
  end

  def squad_image_link_small(squad)
    link_to(image_tag(squad.avatar, options={:style => "height: 30px; width: 30px;", :title => h(squad.name)}), squad_path(squad)) 
  end

  def squad_image_link_medium(squad)
    link_to(image_tag(squad.avatar, options={:style => "height: 55px; width: 55px;"}), squad_path(squad))
  end

  def squad_image_link_large(squad)
    link_to(image_tag(squad.avatar, options={:style => "height: 80px; width: 80px;"}), squad_path(squad))
  end

  def squad_vs_invite(schedule)
    squad_link schedule.squad  
  end

  def squad_score_link(schedule)
    return "#{schedule.home_squad} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_squad}" 
  end    

  def squad_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{squad_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end
