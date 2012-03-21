class Teammate < ActiveRecord::Base
  
  belongs_to    :user
  belongs_to    :manager,       :class_name => "User",        :foreign_key => "manager_id"
  belongs_to    :group,         :class_name => "Group",       :foreign_key => "group_id"
  
  belongs_to    :item,          :polymorphic => true
  belongs_to    :sub_item,      :polymorphic => true
  
  validates_presence_of :user_id, :manager_id
  
  before_create   :make_teammate_code 
  after_create    :send_manager_join_item
  before_destroy  :send_manager_leave_item
  
  # pre join item based teammate  
  def self.my_groups_petitions(items, user)
    find(:all, :select => "distinct teammates.*", 
               :conditions => ["accepted_at is null and item_type = 'Group' and (item_id in (?) or user_id = ?)", user.groups, user]).each do |item| 
      items << item
    end
    return items 
  end
  
  def self.my_challenges_petitions(items, user)
    find(:all, :select => "distinct teammates.*", 
               :conditions => ["accepted_at is null and item_type = 'Challenge' and (item_id in (?) or user_id = ?)", user.challenges, user]).each do |item| 
        items << item
      end
      return items
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

  end
  
  def self.is_breakable_item(leave_user, item, sub_item)
    is_same_user = false
    
    the_creator = RolesUsers.find_item_creator(item)
    the_managers = RolesUsers.find_all_item_managers(item)
    
    is_same_user = (User.find(the_creator.user_id) ==  leave_user)
    
    the_managers.each do |manager| 
      is_same_user = (User.find(manager.user_id) == leave_user) unless is_same_user
    end
    
    unless is_same_user   
      transaction do    
        the_managers.each do |manager| 
          the_manager = User.find(manager.user_id)
          
          the_teammate = self.find_user_manager_item(leave_user, the_manager, item, sub_item)
          the_teammate.destroy unless the_teammate.nil? 
          
          the_teammate = self.find_user_manager_item(the_manager, leave_user, item, sub_item)
          the_teammate.destroy unless the_teammate.nil? 
           
        end
      end
    end
    
    return is_same_user
  end
  
  def self.create_teammate_leave_item(leave_user, item, sub_item)
    
    return if is_breakable_item(leave_user, item, sub_item)
    
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

    when "Cup"
      # TODO:  remove escuadra from cup
      CupsEscuadras.leave_escuadra(escuadra, item) 
      Standing.set_archive_flag(leave_user, item, true)
      Fee.set_archive_flag(leave_user, item, item, true)

    else
    end    
  end

  def self.create_teammate_join_item(requester, approver, item, sub_item)
    self.accept_item(requester, approver, item, sub_item)

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
      approver.has_role!(:member, item)

    when "Challenge"
      ChallengesUsers.join_item(approver, item) 
      ChallengesUsers.join_item(requester, item)
      Cast.create_challenge_cast(item) 
      Fee.create_user_challenge_fees(item)        
      Fee.set_archive_flag(requester, item, item, false)
      Standing.create_cup_challenge_standing(item)
      Standing.set_archive_flag(requester, item, false)
      Cast.update_cast_details(item)         
      Standing.calculate_cup_standing(item.cup)
      Standing.cup_challenges_user_standing(item.cup) 
      Standing.update_cup_challenge_item_ranking(item.cup)
        
      approver.has_role!(:member, item)

    when "Cup"   
      if (sub_item == nil)
        if Escuadra.item_exists?(item)
          @escuadra = Escuadra.new
          @escuadra.name = item.name
          @escuadra.description = item.name
          @escuadra.item = item
          @escuadra.save!
          approver.has_role!(:member, item)
        else
          @escuadra = Escuadra.find_by_item_id_and_item_type(item, item.class.to_s)
        end
      else
        if Escuadra.item_exists?(sub_item)   
          @escuadra = Escuadra.new
          @escuadra.name = sub_item.name
          @escuadra.description = sub_item.name
          @escuadra.item = sub_item
          @escuadra.save!
          sub_item.has_role!(:member, item)
        else
          @escuadra = Escuadra.find_by_item_id_and_item_type(sub_item, sub_item.class.to_s)
        end
      end
      @escuadra.join_escuadra(item)

    else
    end

  end
  
  def self.accept_item(user, manager, item, sub_item)
    transaction do
      accept_one_item(user, manager, item, sub_item, Time.zone.now)
      accept_one_item(manager, user, item, sub_item, Time.zone.now)
    end
  end
    
  def self.find_user_item(user, item)
    find(:first, 
    :conditions => ["user_id = ? and item_id = ? and item_type = ? and sub_item_id is null and sub_item_type is null", user.id, item.id, item.class.to_s])
  end
  
  def self.find_user_manager_item(user, manager, item, sub_item)
    if (sub_item == nil)
      find(:first, 
      :conditions => ["user_id = ? and manager_id = ? and item_id = ? and item_type = ? and 
                       sub_item_id is null and sub_item_type is null", user.id, manager.id, item.id, item.class.to_s])
    else
      find(:first, 
      :conditions => ["user_id = ? and manager_id = ? and item_id = ? and item_type = ? and 
                       sub_item_id = ? and sub_item_type = ?", user.id, manager.id, item.id, item.class.to_s, sub_item.id, sub_item.class.to_s])
    end
  end
  
  def self.user_item_exists?(user, item, sub_item)
    if (sub_item == nil)
      find(:first, 
      :conditions => ["user_id = ? and item_id = ? and item_type = ? and sub_item_id is null and sub_item_type is null", user, item.id, item.class.to_s]).nil?
    else  
      find(:first, 
      :conditions => ["user_id = ? and item_id = ? and item_type = ? and sub_item_id = ? and sub_item_type = ?", user, item.id, item.class.to_s, sub_item.id, sub_item.class.to_s]).nil?
    end
  end
 
  def breakup_item(leave_user, manager)
    if self.sub_item == nil
      @teammates = Teammate.find(:all, 
            :conditions => ["(item_id = ? and item_type = ? and sub_item_id is null and sub_item_type is null) and ((user_id = ? and manager_id = ?) or (user_id = ? and manager_id = ? ))",
              self.item.id, self.item.class.to_s, leave_user.id, manager.id, manager.id, leave_user.id])
    else
      @teammates = Teammate.find(:all, 
            :conditions => ["(item_id = ? and item_type = ? and sub_item_id = ? and sub_item_type = ?) and ((user_id = ? and manager_id = ?) or (user_id = ? and manager_id = ? ))",
              self.item.id, self.item.class.to_s, self.sub_item.id, self.sub_item.class.to_s, leave_user.id, manager.id, manager.id, leave_user.id])
    end
    
    @teammates.each {|teammate| teammate.destroy}
  end
    
  def self.has_item_petition?(sub_item, item)
    petition = false      
    if Teammate.count(:conditions => ["accepted_at is null and item_id = ? and item_type = ? and sub_item_id = ? and sub_item_type = ?", 
                              item.id, item.class.to_s, sub_item.id, sub_item.class.to_s]) > 0
        petition = true
    end        
    return petition
  end
  
  def self.latest_teammates(items)
    all_teammates = find(:all, :select => "id", :conditions => ["accepted_at >= ? and status = 'accepted'", LAST_THREE_DAYS], :order => "id") 
    first_teammates = []

    first_only = true
    all_teammates.each do |teammate| 
      first_teammates << teammate.id if first_only
      first_only = !first_only
    end
    find(:all, :conditions => ["id in (?)", first_teammates], :order => "accepted_at desc").each do |item| 
      items << item
    end
    return items
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
      # UserMailer.delay.deliver_teammate_join(self, self.manager, self.user) if self.group    
    end       
  end

  def send_manager_leave 
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 

    if self.status == "pending"       
      # UserMailer.delay.deliver_teammate_leave(self, self.user, self.manager) if self.group
    end       
  end 
  
  def send_manager_join_item
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 
    # UserMailer.delay.deliver_manager_join_item(self, self.manager, self.user) if self.status == "pending"   
  end

  def send_manager_leave_item
    @send_mail ||= self.manager.teammate_notification?   
    return unless @send_mail 
    # UserMailer.delay.deliver_manager_leave_item(self, self.user, self.manager) if self.status == "pending" 
  end 

  def self.accept_one_item(user, manager, item, sub_item, accepted_at)
    @role_user = RolesUsers.find_item_manager(item)
    @manager = User.find(@role_user.user_id)

    if (@manager == user or @manager == manager)
      request = self.find_user_manager_item(user, manager, item, sub_item) 
      
      unless request.nil?
        request.status = 'accepted'
        request.accepted_at = accepted_at
        request.teammate_code = nil
        request.save!
      end
      
    end
  end

end