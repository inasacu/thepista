class CreateCompanies < ActiveRecord::Migration
  def change
	
		# rake db:migrate VERSION=20130518203222

		# drop_table :companies
		
    create_table :companies do |t|
	    t.string   	:name
	    t.integer  	:city_id,							:default => 1
	    t.integer  	:venue_id
	    t.integer  	:service_id,   				:default => 51
	    t.integer  	:play_id,      				:default => 61
			t.datetime	:starts_at
			t.datetime	:ends_at
	    t.string   	:url
	    t.string   	:language,           	:default => "es"
	    t.boolean  	:public,             	:default => true
	    t.string   	:photo_file_name
	    t.string   	:photo_content_type
	    t.integer  	:photo_file_size
	    t.datetime 	:photo_updated_at
			t.text			:description	
	    t.string   	:api
	    t.string   	:secret
	    t.string   	:slug
	    t.boolean  	:archive,            	:default => false
      t.timestamps
    end
  end
end
