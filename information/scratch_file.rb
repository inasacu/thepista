



https://www.facebook.com/dialog/pagetab?app_id=64553101275&display=popup&next=https://zurb.herokuapp.com/




last_minute_notification


* mandar mensaje cuando se modifican los equipos dentro de las 24 horas 
* mandar mensaje cuando se cambia de convocatoria dentro de las 24 horas

schedule.rb

  def self.last_minute_reminder

  manager_id = RolesUsers.find_item_manager(self.group).user_id
	self.group.users.each do |user|
		if user.last_minute_notification? 
			create_notification_email(self, self, manager_id, user.id, true)
		end
	end
	self.send_reminder_at = Time.zone.now
	self.save!

  end
  
  
  
  

  
matches_controller.rb


	def set_status
		unless current_user == @match.user or is_current_manager_of(@match.schedule.group) 
			warning_unauthorized
			redirect_to root_url
			return
		end

		@type = Type.find(params[:type])
		played = (@type.id == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

		send_last_minute_message = (current_user == @match.user and Time.zone.now + 1.days > @match.schedule.starts_at)

		if @match.update_attributes(:type_id => @type.id, :played => played, :user_x_two => @user_x_two, :status_at => Time.zone.now)
			Scorecard.delay.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)

			if DISPLAY_FREMIUM_SERVICES
				# set fee type_id to same as match type_id
				the_fee = Fee.find(:all, :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", @match.user_id, @match.schedule_id])
				the_fee.each {|fee| fee.type_id = @type.id; fee.save}
			end
			
		end 

		# http://haypista.com/messages/new?schedule_id=ac_la_maso_jornada_3
		if send_last_minute_message
			@schedule = @match.schedule
			if @schedule.send_reminder_at.nil? or @schedule.send_reminder_at < (Time.zone.now - 1.day)
				@schedule.last_minute_reminder 
			end
		end	
	
		redirect_back_or_default('/index')
	end