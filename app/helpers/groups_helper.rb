module GroupsHelper

	# Link to a group (default is by name).
	def group_link(text, item = nil, html_options = nil)
		item_name_link(text, item, html_options)
	end

	def group_show_photo(group, current_user)
		if group.photo_file_name
			return item_image_link_large(group)
		end
		if is_current_manager_of(group)
			"#{I18n.t(:no_photo_for, get_the_controller)}.  #{link_to(I18n.t(:upload), edit_group_path(group))}"
		else  
			return item_image_link_large(group)
		end
	end	

	def group_avatar_image_link(group)
		link_to(image_tag('group_avatar.png', options={:style => "height: 15px; width: 15px;"}), group_path(group)) 
	end

	def group_image_link_small(group)
		link_to(image_tag(group.avatar, options={:style => "height: 30px; width: 30px;", :title => h(group.name)}), group_path(group))
	end

	def group_vs_invite(schedule)
		item_name_link(schedule.group)  
	end

	def group_score_link(schedule, is_second_team=false)
		the_home_group = "#{schedule.home_group}"
		the_away_group = "#{schedule.away_group}"

		if is_second_team
			the_away_group = "<strong>#{the_away_group}</strong>"
		else
			the_home_group = "<strong>#{the_home_group}</strong>"
		end

		return "#{the_home_group} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{the_away_group}".html_safe
	end    

	def group_list(objects)
		return item_list(objects)
	end

	def set_role_add_manager(user, group)
		the_label = label_with_name('role_add_manager', h(group.name))  
		link_to(the_label , set_manager_path(:id => user, :group => group))
	end

	def set_role_remove_manager(user, group)
		the_label = label_with_name('role_remove_manager', h(group.name))   
		link_to(the_label , remove_manager_path(:id => user, :group => group))
	end

	def set_role_add_sub_manager(user, group)
		the_label = label_with_name('role_add_sub_manager', h(group.name))  
		link_to(the_label , set_sub_manager_path(:id => user, :group => group))
	end

	def set_role_remove_sub_manager(user, group)
		the_label = label_with_name('role_remove_sub_manager', h(group.name))   
		link_to(the_label , remove_sub_manager_path(:id => user, :group => group))
	end

	def set_role_add_subscription(user, group)
		the_label = label_with_name('role_add_subscription', h(group.name)) 
		link_to(the_label , set_subscription_path(:id => user, :group => group))
	end

	def set_role_remove_subscription(user, group)
		the_label = label_with_name('role_remove_subscription', h(group.name))
		link_to(the_label , remove_subscription_path(:id => user, :group => group))
	end
end

