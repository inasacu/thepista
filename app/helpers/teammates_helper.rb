module TeammatesHelper


  def the_add_item_petition(user, item)
    the_confirmation = "#{I18n.t(:add_to_item)} #{I18n.t(:from)} #{h(user.name)} #{ I18n.t(:to) } #{h(item.name)}?"
  end

  def the_remove_item_petition(user, item)
    the_confirmation = "#{I18n.t(:fire_from_item)} #{h(item.name)} #{ I18n.t(:to) } #{h(user.name)}?"
  end

  def join_item_link_to(user, item, extend_label=false, unique_label=false)
    the_label = label_name(:add_to_item)
    the_label = "#{the_label} #{I18n.t(:to)} #{h(item.name)}" if extend_label
    the_label = "#{the_label} #{I18n.t(:with)} #{h(user.name)}" if unique_label
    link_to(the_label, join_item_path(:id => item, :item => item.class.to_s, :teammate => user))
  end

  def join_item_sub_item_link_to(user, item, sub_item, extend_label=false)
    the_label = label_name(:add_to_item)
    link_to(the_label, join_item_path(:id => item, :item => item.class.to_s, :sub_id => sub_item, :sub_item => sub_item.class.to_s, :teammate => user)) 
  end	

  def leave_item_link_to(user, item)
    the_label = label_with_name('fire_from_item', h(item.name))
    the_confirmation = the_remove_item_petition(user, item) 
    # link_to(the_label, fire_path(:id => item, :leave => user), :confirm => the_confirmation) 

    # the_label = label_with_name('fire_from_item', item.name)
    # the_confirmation = "#{ label_name(:fire_from_item)} #{the_item} #{ label_name(:to)} #{h(@user.name)}?"
    link_to(the_label, leave_item_path(:id => item, :item => item.class.to_s, :teammate => user), :confirm => the_confirmation) 
  end

  def leave_item_sub_item_link_to(user, item, sub_item)
    the_label = label_with_name('fire_from_item', h(sub_item.name))
    the_confirmation = the_remove_item_petition(item, sub_item)
    link_to(the_label, leave_item_path(:id => item, :item => item.class.to_s, :sub_id => sub_item, :sub_item => sub_item.class.to_s, :teammate => user), :confirm => the_confirmation)
  end

  def manage_item_link_to(user, item, extend_label=false)
    the_label = label_name(:add_to_item)
    the_label = "#{the_label} #{I18n.t(:to)} #{h(item.name)}" if extend_label
    the_confirmation =the_add_item_petition(user, item) 
    link_to(the_label, manage_join_path(:id => item, :teammate => user), :confirm => the_confirmation)
  end
end
