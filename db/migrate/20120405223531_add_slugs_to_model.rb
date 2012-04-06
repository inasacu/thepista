class AddSlugsToModel < ActiveRecord::Migration
	def change

		add_column			:venues,						:slug,			:string
		add_column			:users,							:slug,			:string
		add_column			:payments,					:slug,			:string
		add_column			:challenges,				:slug,			:string
		add_column			:fees,							:slug,			:string
		add_column			:escuadras,					:slug,			:string
		add_column			:markers,						:slug,			:string
		add_column			:matches,						:slug,			:string
		add_column			:cups,							:slug,			:string
		add_column			:games,							:slug,			:string
		add_column			:groups,						:slug,			:string
		add_column			:schedules,					:slug,			:string
		add_column			:installations,			:slug,			:string
		add_column			:classifieds,				:slug,			:string


		add_index 			:venues, 						:slug, 			unique: true
		add_index 			:users, 						:slug, 			unique: true
		add_index 			:payments, 					:slug, 			unique: true
		add_index 			:challenges, 				:slug, 			unique: true
		add_index 			:fees, 							:slug, 			unique: true
		add_index 			:escuadras, 				:slug, 			unique: true
		add_index 			:markers, 					:slug, 			unique: true
		add_index 			:matches, 					:slug, 			unique: true
		add_index 			:cups, 							:slug, 			unique: true
		add_index 			:games, 						:slug, 			unique: true
		add_index 			:groups, 						:slug, 			unique: true
		add_index 			:schedules, 				:slug, 			unique: true
		add_index 			:installations, 		:slug, 			unique: true
		add_index 			:classifieds, 			:slug, 			unique: true

	end
end
