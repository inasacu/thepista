
def view_schedule_rating(schedule)
  if schedule.played? or Time.zone.now > schedule.starts_at
    my_rating = ""
			overall_rating = ""
    return set_content_tag_safe(:td, "#{my_rating}&nbsp;&nbsp;#{overall_rating}", "last_upcoming")

  elsif Time.zone.now < schedule.starts_at
    the_label = ""
    
    schedule.matches.each do |match| 
      the_font_begin =  ""
      the_font_end = ""
				the_match_type_name_downcase = (match.type_name).downcase
				the_font=""
				
      case match.type_id
      when 1
					the_font = the_font_green(the_match_type_name_downcase)
      when 2
					the_font = the_font_yellow(the_match_type_name_downcase)
      when 3
					the_font = the_font_red(the_match_type_name_downcase)
      end
      the_label = "<STRONG>#{I18n.t(:your_roster_status)}</STRONG> #{the_font}" if is_current_same_as(match.user)
    end
    
			the_match_link = match_all_my_link(schedule, current_user, false, true)
			
			if the_match_link.blank?
				the_group = schedule.group
				is_member_group = the_group ? is_current_member_of(the_group) : false
				show_join_option = (!is_member_group and !has_current_item_petition(the_group))
				the_match_link = set_image_and_link_h6(join_item_link_to(current_user, the_group), 'user_add') if show_join_option
			end
		
			the_label_link = "#{the_label}<br/>#{the_match_link}"
			
			if the_match_link.blank?
				# the_label_link = set_image_and_link_h6(join_item_link_to(current_user, the_group, false, false, schedule), 'user_add') #if show_join_option
			end
			
    return set_content_tag_safe(:td, the_label_link, "last_upcoming")
  end
end





def self.create_teammate_pre_join_item(join_user, manager, item, sub_item)
  
  return if join_user == manager    
  @role_user = RolesUsers.find_item_manager(item)
  @manager = User.find(@role_user.user_id)

  if @manager == manager 
    if self.user_item_exists?(join_user, item, sub_item)
      transaction do
        if (sub_item == nil)
          create(:user => join_user, :manager => @manager, :item_id => item.id, :item_type => item.class.to_s, :status => 'pending')
          create(:user => @manager, :manager => join_user, :item_id => item.id, :item_type => item.class.to_s, :status => 'requested')
        else
          create(:user => join_user, :manager => @manager, :item_id => item.id, :item_type => item.class.to_s, 
                :sub_item_id => sub_item.id, :sub_item_type => sub_item.class.to_s, :status => 'pending')
          create(:user => @manager, :manager => join_user, :item_id => item.id, :item_type => item.class.to_s, 
                :sub_item_id => sub_item.id, :sub_item_type => sub_item.class.to_s, :status => 'requested')
        end
      end
    end
  end

	self.accept_item(join_user, @manager, item, sub_item) if item.automatic_petition
end


def join_item
	@schedule = nil
  @role_user = RolesUsers.find_item_manager(@item)
  @manager = User.find(@role_user.user_id)
  @mate = User.find(params[:teammate])

	Teammate.create_teammate_pre_join_item(@mate, @manager, @item, @sub_item)
	
	if params[:schedule]
		@schedule = Schedule.find(params[:schedule])
		Teammate.create_teammate_join_item(@manager, @mate, @item, @sub_item, @schedule)
	else
		Teammate.delay.create_teammate_join_item(@manager, @mate, @item, @sub_item) 
	end
	

  flash[:notice] = I18n.t(:to_join_item_message_sent)
  redirect_back_or_default('/index')
end


def join_item_link_to(user, item, extend_label=false, unique_label=false, schedule=nil)
  the_label = label_name(:add_to_item)
  the_label = "#{the_label} #{I18n.t(:to)} #{h(item.name)}" if extend_label
  the_label = "#{the_label} #{I18n.t(:with)} #{h(user.name)}" if unique_label
	
	if schedule.nil?
  	link_to(the_label, join_item_path(:id => item, :item => item.class.to_s, :teammate => user))
  else
		link_to(the_label, join_item_path(:id => item, :item => item.class.to_s, :teammate => user, :schedule => schedule))
	end
end

# create a record in the match table for specific teammate and only for specific schedule 
def self.create_item_schedule_match(schedule, user)
    type_id = 1         # set to convocado
    
    # assign unique user id and start_date code for changing status through email
    the_encode = "#{rand(36**8).to_s(36)}#{schedule.id}#{rand(36**8).to_s(36)}"
    block_token  = Base64::encode64(the_encode)

    self.create!(:status_at => Time.zone.now, :schedule_id => schedule.id, :group_id => schedule.group_id, :user_id => user.id,  
                 :type_id => type_id, :played => schedule.played, :block_token => block_token) if Match.schedule_user_exists?(schedule, user)
end


