class Teammate < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :manager, :class_name => "User", :foreign_key => "manager_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  validates_presence_of :user_id, :manager_id
  
  before_create :make_teammate_code  
  
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
      accepted_at = Time.now
      accept_one_team(user, manager, group, accepted_at)
      accept_one_team( manager, user, group, accepted_at)
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
    self.teammate_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
    
  private
  
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
end