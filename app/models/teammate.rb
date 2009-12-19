class Teammate < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :manager,    :class_name => "User", :foreign_key => "manager_id"
  belongs_to :group,      :class_name => "Group", :foreign_key => "group_id"
  belongs_to :tournament, :class_name => "Tournament", :foreign_key => "tournament_id"
  
  validates_presence_of :user_id, :manager_id
  
  before_create :make_teammate_code 
  after_create  :send_manager_join
  before_destroy :send_manager_leave 
  
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
  
  def self.create_teammate_join_tour(tournament, mate, manager)
    @role_user = RolesUsers.find_tour_manager(tournament)
    @manager = User.find(@role_user.user_id)
    Teammate.join_tour(mate, manager, tournament)
    @teammate = Teammate.find_by_user_id_and_tournament_id(mate, tournament)    
  end
  
  def self.create_teammate_leave_tour(tournament, leave_user)
    @role_user = RolesUsers.find_tour_manager(tournament)
    @manager = User.find(@role_user.user_id) 
    TournamentsUsers.leave_tour(leave_user, tournament)
    Teammate.breakup_tour(leave_user, @manager, tournament)
    leave_user.has_no_role!(:member, tournament)
    # Standing.set_archive_flag(leave_user, tournament, true)
    # Clash.set_archive_flag(leave_user, tournament, true)
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
  
  def self.create_teammate_details_tour(requester, approver, tournament)
    self.accept_tour(requester, approver, tournament)
    
    TournamentsUsers.join_tour(approver, tournament) 
    TournamentsUsers.join_tour(requester, tournament)
    
    # Standing.create_user_standing(approver, tournament)
    # Standing.create_user_standing(requester, tournament)
    # Standing.set_archive_flag(approver, tournament, false)

    approver.has_role!(:member, tournament)
    
    # tournament.meets.each do |meet|
    #   Clash.create_meet_clash(meet)
    #   Fee.create_user_fees(meet)
    # end
    
    # Clash.set_archive_flag(approver, tournament, false)    
  end
      
  # Return true if the users are (possibly pending) teammates.
  def self.exists?(user, manager)
    not find_by_user_id_and_manager_id(user, manager).nil?
  end
  
  # Return true if the users are (possibly pending) teammates.
  def self.group_exists?(user, group)
    not find_by_user_id_and_group_id(user, group).nil?
  end
  
  def self.tour_exists?(user, tournament)
    not find_by_user_id_and_tournament_id(user, tournament).nil?
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
  
  def self.join_tour(user, manager, tournament)
    unless user == manager or Teammate.tour_exists?(user, tournament)
      transaction do
        create(:user => user, :manager => manager, :tournament => tournament, :status => 'pending')
        create(:user => manager, :manager => user, :tournament => tournament, :status => 'requested')
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

  def self.accept_tour(user, manager, tournament)
    transaction do
      accepted_at = Time.zone.now
      accept_one_tour(user, manager, tournament, accepted_at)
      accept_one_tour(manager, user, tournament, accepted_at)
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

  def self.breakup_tour(user, manager, tournament)
    if Teammate.exists?(user, manager)
      transaction do    
        destroy(find_by_user_id_and_manager_id_and_tournament_id(user, manager, tournament)) 
        destroy(find_by_user_id_and_manager_id_and_tournament_id(manager, user, tournament)) 
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
  
  # Update the db with one side of an accepted teammates request.
  def self.accept_one_side(user, manager, accepted_at)
    request = find_by_user_id_and_manager_id(user, manager)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.teammate_code = nil
    request.save!
  end
  
  def self.accept_one_team(user, manager, group, accepted_at)
    request = find_by_user_id_and_manager_id_and_group_id(user, manager, group)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.teammate_code = nil
    request.save!
  end

  def self.accept_one_tour(user, manager, tournament, accepted_at)
    request = find_by_user_id_and_manager_id_and_tournament_id(user, manager, tournament)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.teammate_code = nil
    request.save!
  end
end