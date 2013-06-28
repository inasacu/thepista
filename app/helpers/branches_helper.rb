module BranchesHelper

	def get_branch_calendar_details
		the_items = []
		all_timetables = []
		the_schedule_day_numbers = []
		group_timetables = []

		is_holiday = nil
		the_day_starts_at = nil
		the_day_ends_at = nil
		the_time_frame = nil

		is_same_day = false
		is_last_blank_days = true

		all_weekday_numbers = [1,2,3,4,5,6,7]
		the_month = []
		the_week = []

		first_day = @current_user_zone.at_beginning_of_month
		last_day = @current_user_zone.at_end_of_month	
		the_day_of_month = first_day	

		the_first_day_of_month = 1	
		the_last_day_of_month = days_in_month(@current_user_zone.month)
		the_current_day_number = @current_user_zone.day

		the_first_day_of_month = @current_user_zone.day	
		the_last_day_of_month = @current_user_zone.day + DAYS_IN_A_WEEK
		the_current_day_number = @current_user_zone.day

		the_holidays = Holiday.get_holiday_first_to_last_month(first_day, last_day)

		@the_schedules_item = Schedule.get_schedule_item_first_to_last_month(first_day, last_day, @group.item) 
		@the_schedules_item.each { |item| the_items << item }

		# all_timetables = get_item_month_timetables(the_items, @the_holidays, the_day_of_month, the_first_day_of_month, the_last_day_of_month, @group)

		@branch.groups.each do |group|
			the_jornada = 1
			previous_schedule = Schedule.first_group_schedule(group)
			the_jornada = previous_schedule.jornada + 1 unless previous_schedule.nil?

			group_timetables = get_item_month_timetables(the_items, the_holidays, the_day_of_month, the_first_day_of_month, the_last_day_of_month, group, the_jornada)
			group_timetables.each { |item| all_timetables << item }
		end

		the_items = all_timetables
		the_items.each { |item| the_schedule_day_numbers << item.starts_at.day }
		the_items = the_items.sort_by { |a| [ a.starts_at, a.group_name ] }
		
		return the_items
	end

end
