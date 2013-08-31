module CompaniesHelper


	def get_company_team_link(company)
		the_first_team_link = true
		has_group_timetable = false
		the_team_link = ""
		
		company.branches.each do |branch| 
			is_group_branch_manager = (current_user.is_manager_of?(branch))

			if is_group_branch_manager 
				branch.groups.each do |group|
					has_group_timetable = Timetable.item_timetable(group).count > 0

					the_team_link += ", " unless the_first_team_link
					unless has_group_timetable
						the_first_team_link = false
						the_team_link += "#{link_to(group.name, new_timetable_url(:group_id => group))} " 
					end
				end
			end

		end

		return the_first_team_link, has_group_timetable, the_team_link
	end


end
