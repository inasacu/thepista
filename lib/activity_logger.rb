module ActivityLogger

  def add_activities(options = {})
    user = options[:user]
    include_user = options[:include_user]

    if Activity.exists?(options[:item], user)
      activity = options[:activity] || Activity.create!(:item => options[:item], :user => user)
    end
  end

end