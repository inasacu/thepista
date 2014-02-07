class Mobile::UserEventData
  
  attr_accessor :event_id, :user_id, :user_event_state
  
  def initialize(match)
    if !match.nil?
      @event_id = match.schedule.id
      @user_id = match.user.id
      @user_event_state = match.type.id
    end
  end
  
end