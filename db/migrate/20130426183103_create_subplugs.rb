class CreateSubplugs < ActiveRecord::Migration
	def change

		# drop_table	:subplugs
		drop_table	:enchufados

		create_table :subplugs do |t|
			t.string			:name
			t.integer			:enchufado_id
			t.integer  		:venue_id,				:default => 999
			t.integer  		:play_id,     		:default => 61
			t.integer  		:service_id,  		:default => 51
			t.string			:url
			t.string			:slug
			t.boolean			:archive,				:default => false
			t.timestamps
		end

		create_table :enchufados do |t|
			t.string   	:name
			t.string   	:url
			t.string   	:language,    		:default => "es"
			t.boolean		:public,					:default => true
			t.integer  	:venue_id
			t.integer  	:category_id
			t.integer  	:play_id,     		:default => 61
			t.integer  	:service_id,  		:default => 51
			t.string   	:api
			t.string   	:secret
			t.string   	:photo_file_name
			t.string   	:photo_content_type
			t.integer  	:photo_file_size
			t.datetime 	:photo_updated_at
			t.datetime 	:created_at,      :null => false
			t.datetime 	:updated_at,      :null => false
			t.string   	:slug
			t.boolean  	:archive,     		:default => false
		end

		change_column	:groups,		:marker_id,						:integer,				:default => 2
		change_column	:groups,		:installation_id,			:integer,				:default => 999
		
	end
end
