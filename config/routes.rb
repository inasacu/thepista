ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'

  map.login                 'login',                                  :controller => 'user_sessions',   :action => 'new'
  map.logout                'logout',                                 :controller => 'user_sessions',   :action => 'destroy'
  map.signup                'signup',                                 :controller => 'users',           :action => 'signup'

  map.recent_activity       'recent_activity',                        :controller => 'users',           :action => 'recent_activity'
  map.my_openid			        'my_openid',			                        :controller => 'users',           :action => 'third_party'
  map.team_list			        'team_list',			                        :controller => 'groups',          :action => 'team_list'
  map.team_roster		        'team_roster',		                        :controller => 'schedules',       :action => 'team_roster'
  map.team_last_minute		  'team_last_minute',		                    :controller => 'schedules',       :action => 'team_last_minute'
  map.team_no_show		      'team_no_show',			                      :controller => 'schedules',       :action => 'team_no_show'
  map.team_unavailable      'team_unavailable',			                  :controller => 'schedules',       :action => 'team_unavailable'
  map.marker_list		        'marker_list',			                      :controller => 'markers',         :action => 'marker_list'

  map.join_team   			    'teammates/:id/join_team/:teammate',    	:controller => 'teammates',       :action => 'join_team'
  map.leave_team		  	    'teammates/:id/leave_team/:teammate',    	:controller => 'teammates',       :action => 'leave_team'
  map.join_team_accept	    'teammates/:id/join_team_accept/',        :controller => 'teammates',       :action => 'join_team_accept'
  map.join_team_decline	    'teammates/:id/join_team_decline/',       :controller => 'teammates',       :action => 'join_team_decline'  
  
  map.set_sub_manager     	'users/:id/set_sub_manager/:group',    		:controller => 'users',    		    :action => 'set_sub_manager'
  map.remove_sub_manager  	'users/:id/remove_sub_manager/:group', 		:controller => 'users',     	    :action => 'remove_sub_manager'
  map.set_subscription   	  'users/:id/set_subscription/:group',    	:controller => 'users',    		    :action => 'set_subscription'
  map.remove_subscription   'users/:id/remove_subscription/:group',  	:controller => 'users',    		    :action => 'remove_subscription' 
  map.set_moderator   		  'users/:id/set_moderator/:group',    		  :controller => 'users',    		    :action => 'set_moderator'
  map.remove_moderator   	  'users/:id/remove_moderator/:group',  		:controller => 'users',    		    :action => 'remove_moderator'   
  map.petition              'users/petition',                         :controller => 'users',           :action => 'petition'
  
  map.set_available               'users/set_available',  		        :controller => 'users',    		    :action => 'set_available'
  map.set_private_phone           'users/set_private_phone',  		    :controller => 'users',    		    :action => 'set_private_phone'
  map.set_private_profile         'users/set_private_profile',  		  :controller => 'users',    		    :action => 'set_private_profile'
  map.set_enable_comments         'users/set_enable_comments',  		  :controller => 'users',    		    :action => 'set_enable_comments'
  map.set_teammate_notification   'users/set_teammate_notification',  :controller => 'users',    		    :action => 'set_teammate_notification'
  map.set_message_notification    'users/set_message_notification',  	:controller => 'users',    		    :action => 'set_message_notification'
  map.set_comment_notification    'users/set_comment_notification',  	:controller => 'users',    		    :action => 'set_comment_notification'
  
  map.match_team            'matches/:id/set_team',                   :controller => 'matches',         :action => 'set_team'
  map.match_status          'matches/:id/set_status/:type',           :controller => 'matches',         :action => 'set_status'
  map.reply_message         'messages/:id/reply',                     :controller => 'messages',        :action => 'reply'
  map.upcoming_schedule     'home/upcoming_schedule',                 :controller => 'home',            :action => 'upcoming_schedule'         
  
  map.resources   :user_sessions,   :as => 'try_again'

  map.resources   :users,           :as => 'jugadores',       :collection  => { :list => :get, :recent_activity => :get, :search => :get }  
  map.resources   :schedules,       :as => 'eventos',         :collection  => { :list => :get, :search => :get }          
  map.resources   :groups,          :as => 'equipos',         :collection  => { :list => :get, :search => :get }
  map.resources   :markers,         :as => 'centros'
  map.resources   :scorecards,      :as => 'classificaciones'
  map.resources   :matches,         :as => 'jornadas'

  map.resources :teammates
  map.resources :posts
  map.resources :topics
  map.resources :forums
  map.resources :entries
  map.resources :comments
  map.resources :blogs
  map.resources   :types,         :as => 'tipos'
  map.resources   :sports,        :as => 'deportes'
  map.resources   :roles,         :as => 'responsabilidades'
  map.resources   :practices,     :as => 'entrenamientos',  :collection  => { :list => :get, :search => :get }          
  map.resources :payments
  map.resources :fees
  map.resources :password_resets
  
  map.resources :connections
  map.resources :messages, :collection => { :sent => :get, :trash => :get }

  map.resources :users do |user|
    user.resources :messages
  end

  map.resources :blogs do |blog|
    blog.resources :posts do |post|
      post.resources :comments
    end
  end

  map.resources :forums do |forums|
    forums.resources :topics do |topic|
      topic.resources :posts
    end
  end


  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end