class Mobile::GroupM
  
  attr_accessor :legacy_id, :name, :second_team, :sport, :conditions, 
                :number_of_members, :managers, :player_limit, :number_of_events
  
  def initialize(group=nil)
    if !group.nil?
      @legacy_id = group.id
      @name = group.name
      @second_team = group.second_team
      @player_limit = group.player_limit

      if group.sport
        @sport = {:id => group.sport.id, :name => group.sport.name}
      end

      if group.the_managers
        managers = Array.new
        group.the_managers.each do |m|
          new_m = {:id => m.user.id, :name => m.user.name} 
          if !managers.include? new_m
            managers << new_m
          end
        end
        @managers = managers
      end

      if group.schedules
        @number_of_events = group.schedules.count
      end

      @conditions = group.conditions
      @number_of_members = group.users.size
    end
  end

  def self.build_from_groups(groups)
    groups_array = Array.new
    groups.each do |group|
      group_m = Mobile::GroupM.new(group)
      groups_array << group_m
    end
    return groups_array
  end 

  # MOBILE --------------------------
  def self.active_schedules(the_group)
    the_group.schedules.where("starts_at >= ? and archive = false", Time.zone.now)
  end

  def self.active_events(group_id)
    begin
      the_group = Group.find(group_id)
      schedules = the_group.schedules.where("starts_at >= ?", Time.zone.now)
      events = Mobile::EventM.build_from_schedules(schedules)
    rescue Exception => exc
      Rails.logger.error("Exception while getting events from group #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      events = nil
    end
    return events
  end

  def self.get_members(group_id)
    begin
      the_group = Group.find(group_id)
      users = the_group.users
      users_m = Mobile::UserM.build_from_users(users)
    rescue Exception => exc
      Rails.logger.error("Exception while getting events from group #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      users_m = nil
    end
    return users_m
  end
  
  def self.starred
    begin
      starred = Mobile::GroupM.build_from_groups(Group.limit(5))
    rescue Exception => exc
      Rails.logger.error("Exception while getting starred groups #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      starred = nil
    end
    return starred
  end
  
  def self.user_groups(user_id)
    begin
      user = User.find(user_id)
      groups = Mobile::GroupM.build_from_groups(user.groups)
    rescue Exception => exc
      Rails.logger.error("Exception while getting user groups #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      groups = nil
    end
    return groups
  end

  def self.create_new(group_map=nil)
    if group_map
      new_group = Group.new
      begin
        new_group_mobile = nil
        Group.transaction do
          # gets the user who is creating the group
          user_id = group_map["group_creator"]
          creator = User.find(user_id)

          # sets group properties
          new_group.name = group_map["group_name"]
          new_group.sport_id = group_map["group_sport"]
          new_group.name_to_second_team
          new_group.default_conditions
          new_group.sport_to_points_player_limit
          new_group.time_zone = creator.time_zone if !creator.time_zone.nil?

          # creates the group
          new_group.save!

          # creates roles for creator
          new_group.create_group_roles(creator)

          new_group_mobile = Mobile::GroupM.new(new_group)

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while creating group #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        new_group_mobile = nil
      end

      return new_group_mobile
    else
      Rails.logger.debug "Null map for the group info"
      return nil
    end
  end

  def self.add_member(group_id=nil, user_id=nil)
    if group_id and user_id
      add_response = nil
      begin
        Group.transaction do
          # get user
          new_member = User.find(user_id)

          # get group
          the_group = Group.find(group_id)

          # add member role to user
          new_member.has_role!(:member,  the_group)

          # relate group with user 
          GroupsUsers.join_team(new_member, the_group)

          # update scorecards
          Scorecard.create_user_scorecard(new_member, the_group)

          # prepare response
          the_group = Group.find(group_id)
          add_response = Mobile::GroupM.new(the_group)

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while adding member to group #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        add_response = nil
      end

      return add_response
    else
      Rails.logger.debug "Null group id and user id"
      return nil
    end
  end

  def self.get_info_related_to_user(group_id=nil, user_id=nil)
    if group_id and user_id
      group_info = nil
      begin
        Group.transaction do
          the_group = Group.find(group_id)
          the_user = User.find(user_id)

          user_data = Hash.new
          user_data[:user_id] = user_id
          user_data[:is_member] = the_user.has_role?(:member,  the_group)
          user_data[:is_creator] = the_user.has_role?(:creator,  the_group)
          user_data[:is_manager] = the_user.has_role?(:manager,  the_group)

          group_info = Hash.new
          group_info[:group] = Mobile::GroupM.new(the_group)
          group_info[:user_data] = user_data
          

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while getting group info #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        group_info = nil
      end

      return group_info
    else
      Rails.logger.debug "Null group id and user id"
      return nil
    end
  end
  
end