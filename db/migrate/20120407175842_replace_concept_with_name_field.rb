class ReplaceConceptWithNameField < ActiveRecord::Migration
	def up
		rename_column 			:schedules,				:concept,						:name
		rename_column 			:classifieds,			:concept,						:name
		rename_column 			:fees,						:concept,						:name
		rename_column 			:games,						:concept,						:name
		rename_column 			:payments,				:concept,						:name
		rename_column 			:reservations,		:concept,						:name
	end

	def down
		rename_column 			:schedules,				:name,						:concept
		rename_column 			:classifieds,			:name,						:concept
		rename_column 			:fees,						:name,						:concept
		rename_column 			:games,						:name,						:concept
		rename_column 			:payments,				:name,						:concept
		rename_column 			:reservations,		:name,						:concept
	end
end
