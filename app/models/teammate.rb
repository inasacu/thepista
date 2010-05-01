class Teammate < ActiveRecord::Base
  
  belongs_to    :user
  belongs_to    :manager,       :class_name => "User",        :foreign_key => "manager_id"
  belongs_to    :group,         :class_name => "Group",       :foreign_key => "group_id"
  belongs_to    :tournament,    :class_name => "Tournament",  :foreign_key => "tournament_id"
  
  belongs_to    :item,          :polymorphic => true
  
  validates_presence_of :user_id, :manager_id
  
  before_create :make_teammate_code 
  # after_create  :send_manager_join
  # before_destroy :send_manager_leave 
  
  after_create    :send_manager_join_item
  before_destroy  :send_manager_leave_item
  
  # migrate group to an item based teammate
  def self.create_teammate_join_item(join_user, manager, item)
    
    return if join_user == manager    
    @role_user = RolesUsers.find_item_manager(item)
    @manager = User.find(@role_user.user_id)

    if @manager == manager 
      if self.user_item_exists?(join_user, item)
        transaction do
          create(:user => join_user, :manager => @manager, :item_id => item.id, :item_type => item.class.to_s, :status => 'pending')
          create(:user => @manager, :manager => join_user, :item_id => item.id, :item_type => item.class.to_s, :status => 'requested')
        end
      end
    end

  end
  
  def self.create_teammate_leave_item(leave_user, manager, item)
    @role_user = RolesUsers.find_item_manager(item)
    @manager = User.find(@role_user.user_id) 

    # if @manager == manager or leave_user == manager
      
      if self.user_item_exists?(leave_user, item)
        transaction do    
          destroy(self.find_user_manager_item(leave_user, @manager, item)) 
          destroy(self.find_user_manager_item(@manager, leave_user, item)) 
        end
      end    

      leave_user.has_no_role!(:member, item)

      case item.class.to_s
      when "Group"
        GroupsUsers.leave_team(leave_user, item)  
        Scorecard.set_archive_flag(leave_user, item, true)
        Match.set_archive_flag(leave_user, item, true)

      when "Challenge"
        ChallengesUsers.leave_item(leave_user, item)
        Standing.set_archive_flag(leave_user, item, true)
        Cast.set_remove_cast(leave_user, item)   
        Fee.set_archive_flag(leave_user, item, item, true)

      else
      end
    # end
    
  end

  def self.create_teammate_item_details(requester, approver, item)
    self.accept_item(requester, approver, item)
    approver.has_role!(:member, item)
    
    case item.class.to_s
    when "Group"
      GroupsUsers.join_team(approver, item) 
      GroupsUsers.join_team(requester, item)

      Scorecard.create_user_scorecard(approver, item)
      Scorecard.create_user_scorecard(requester, item)
      Scorecard.set_archive_flag(approver, item, false)

      item.schedules.each do |schedule|
        Match.create_schedule_match(schedule)
        Fee.create_user_fees(schedule)
      end

      Match.set_archive_flag(approver, item, false)
      
    when "Challenge"
        ChallengesUsers.join_item(approver, item) 
        ChallengesUsers.join_item(requester, item)
        Standing.create_cup_challenge_standing(item)
        Cast.create_challenge_cast(item) 
        Fee.create_user_challenge_fees(item)  
        Standing.set_archive_flag(leave_user, item, false)
        Fee.set_archive_flag(leave_user, item, item, false)    
    else
    end
       
  end
  
  def self.accept_item(user, manager, item)
    transaction do
      accept_one_item(user, manager, item, Time.zone.now)
      accept_one_item(manager, user, item, Time.zone.now)
    end
  end
    
  def self.find_user_item(user, item)
    find(:first, :conditions => ["user_id = ? and item_id = ? and item_type = ?", user.id, item.id, item.class.to_s])
  end
  
  def self.find_user_manager_item(user, manager, item)
    find(:first, :conditions => ["user_id = ? and manager_id = ? and item_id = ? and item_type = ?", user.id, manager.id, item.id, item.class.to_s])
  end
  
  def self.user_item_exists?(user, item)
    find_by_user_id_and_item_id_and_item_type(user, item.id, item.class.to_s).nil?
  end
    
  # original team join methods
  def self.create_teammate_join_team(group, mate, manager)
    @role_user = RolesUsers.find_team_manager(group)
    @manager = User.find(@role_user.user_id)
    Teammate.join(mate, manager, group)
    @teammate = Teammate.find_by_user_id_and_group_id(mate, group)    
  end
  
  def self.create_teammate_leave_team(group, leave_user)
    @role_user = RolesUsers.find_team_manager(group)
    @manager = User.find(@role_user.user_id) 
    GroupsUsers.leave_team(leave_user, group)
    Teammate.breakup(leave_user, @manager, group)
    leave_user.has_no_role!(:member, group)
    Scorecard.set_archive_flag(leave_user, group, true)
    Match.set_archive_flag(leave_user, group, true)
  end

  def self.create_teammate_details(requester, approver, group)
    self.accept(requester, approver, group)

    GroupsUsers.join_team(approver, group) 
    GroupsUsers.join_team(requester, group)

    Scorecard.create_user_scorecard(approver, group)
    Scorecard.create_user_scorecard(requester, group)
    Scorecard.set_archive_flag(approver, group, false)

    approver.has_role!(:member, group)

    group.schedules.each do |schedule|
      Match.create_schedule_match(schedule)
      Fee.create_user_fees(schedule)
    end

    Match.set_archive_flag(approver, group, false)    
  end
      
  # Return true if the users are (possibly pending) teammates.
  def self.exists?(user, manager)
    not find_by_user_id_and_manager_id(user, manager).nil?
  end
  
  # Return true if the users are (possibly pending) teammates.
  def self.group_exists?(user, group)
    not find_by_user_id_and_group_id(user, group).nil?
  end
 
  # Record a pending manager request.
  def self.request(user, manager)
    unless user == manager or Teammate.exists?(user, manager)
      transaction do
        create(:user => user, :manager => manager, :status => 'pending')
        create(:user => manager, :manager => user, :status => 'requested')
      end
    end
  end
  
  # Record a pending teammate request.
  def self.join(user, manager, group)
    unless user == manager or Teammate.group_exists?(user, group)
      transaction do
        create(:user => user, :manager => manager, :group => group, :status => 'pending')
        create(:user => manager, :manager => user, :group => group, :status => 'requested')
      end
    end
  end
  
  def self.accept(user, manager, group)
    transaction do
      accepted_at = Time.zone.now
      accept_one_team(user, manager, group, accepted_at)
      accept_one_team(manager, user, group, accepted_at)
    end
  end
  
  # Delete a teammates or cancel a pending request.
  def self.breakup(user, manager, group)
    if Teammate.exists?(user, manager)
      transaction do    
        destroy(find_by_user_id_and_manager_id_and_group_id(user, manager, group)) 
        destroy(find_by_user_id_and_manager_id_and_group_id(manager, user, group)) 
      end
    end
  end
 
  protected    
  def make_teammate_code
    self.teammate_code = Digest::SHA1.hexdigest( Time.zone.now.to_s.split(//).sort_by {rand}.join )
  end
    
  private
  
  def send_manager_join
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 

    if self.status == "pending"   
      # UserMailer.deliver_teammate_join(self, self.manager, self.user) if self.group or self.tournament 
      UserMailer.send_later(:deliver_teammate_join, self, self.manager, self.user) if self.group or self.tournament     
    end       
  end

  def send_manager_leave 
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 

    if self.status == "pending"       
      # UserMailer.deliver_teammate_leave(self, self.user, self.manager) if self.group or self.tournament  
      UserMailer.send_later(:deliver_teammate_leave, self, self.user, self.manager) if self.group or self.tournament  
    end       
  end 
  
  def send_manager_join_item
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 
    UserMailer.send_later(:deliver_manager_join_item, self, self.manager, self.user) if self.status == "pending"   
  end

  def send_manager_leave_item
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 
    UserMailer.send_later(:deliver_manager_leave_item, self, self.user, self.manager) if self.status == "pending" 
  end 
  
  def self.accept_one_team(user, manager, group, accepted_at)
    request = find_by_user_id_and_manager_id_and_group_id(user, manager, group)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.teammate_code = nil
    request.save!
  end

  def self.accept_one_item(user, manager, item, accepted_at)
    @role_user = RolesUsers.find_item_manager(item)
    @manager = User.find(@role_user.user_id)

    if @manager == user or @manager == manager
      request = self.find_user_manager_item(user, manager, item) 
      request.status = 'accepted'
      request.accepted_at = accepted_at
      request.teammate_code = nil
      request.save!
    end
  end

end