ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'
  
  # rpxnow implementation
  map.rpx_token_sessions    'rpx_token_sessions',                         :controller => "user_sessions",   :action => "rpx_create"
  map.rpx_signup            '/rpx_signup',                                :controller => 'users',           :action => 'rpx_new'
  map.rpx_create            'users/rpx_create',                           :controller => 'users',           :action => 'rpx_create'
  
  map.login                 'login',                                      :controller => 'user_sessions',   :action => 'new'
  map.logout                'logout',                                     :controller => 'user_sessions',   :action => 'destroy'
  map.signup                'signup',                                     :controller => 'users',           :action => 'signup'  
  map.language              'set_language',                               :controller => 'users',           :action => 'set_language'
  map.remove_openid         'remove_openid',                              :controller => 'users',           :action => 'remove_openid'

  map.recent_activity       'recent_activity',                            :controller => 'users',           :action => 'recent_activity'
  map.my_openid			        'my_openid',			                            :controller => 'users',           :action => 'third_party'
  map.team_list			        'team_list',			                            :controller => 'groups',          :action => 'team_list'
  map.team_roster		        'team_roster',		                            :controller => 'schedules',       :action => 'team_roster'
  map.team_last_minute		  'team_last_minute',		                        :controller => 'schedules',       :action => 'team_last_minute'
  map.team_no_show		      'team_no_show',			                          :controller => 'schedules',       :action => 'team_no_show'
  map.team_unavailable      'team_unavailable',			                      :controller => 'schedules',       :action => 'team_unavailable'
  map.marker_list		        'marker_list',			                          :controller => 'markers',         :action => 'marker_list'
  map.challenge_list			  'challenge_list',			                        :controller => 'challenges',      :action => 'challenge_list'

  map.join_team   			    'teammates/:id/join_team/:teammate',    	    :controller => 'teammates',       :action => 'join_team'
  map.leave_team		  	    'teammates/:id/leave_team/:teammate',    	    :controller => 'teammates',       :action => 'leave_team'
  map.join_team_accept	    'teammates/:id/join_team_accept/',            :controller => 'teammates',       :action => 'join_team_accept'
  map.join_team_decline	    'teammates/:id/join_team_decline/',           :controller => 'teammates',       :action => 'join_team_decline' 
   
  map.join_item   			    'teammates/:id/join_item/:teammate',    	    :controller => 'teammates',       :action => 'join_item'
  map.leave_item		  	    'teammates/:id/leave_item/:teammate',    	    :controller => 'teammates',       :action => 'leave_item'
  map.join_item_accept	    'teammates/:id/join_item_accept',             :controller => 'teammates',       :action => 'join_item_accept'
  map.join_item_decline	    'teammates/:id/join_item_decline',            :controller => 'teammates',       :action => 'join_item_decline'
  
  map.set_manager     	    'users/:id/set_manager/:group',    		        :controller => 'users',    		    :action => 'set_manager'
  map.remove_manager  	    'users/:id/remove_manager/:group', 		        :controller => 'users',     	    :action => 'remove_manager'
  map.set_sub_manager     	'users/:id/set_sub_manager/:group',    		    :controller => 'users',    		    :action => 'set_sub_manager'
  map.remove_sub_manager  	'users/:id/remove_sub_manager/:group', 		    :controller => 'users',     	    :action => 'remove_sub_manager'
  map.set_subscription   	  'users/:id/set_subscription/:group',    	    :controller => 'users',    		    :action => 'set_subscription'
  map.remove_subscription   'users/:id/remove_subscription/:group',  	    :controller => 'users',    		    :action => 'remove_subscription' 
  map.set_moderator   		  'users/:id/set_moderator/:group',    		      :controller => 'users',    		    :action => 'set_moderator'
  map.remove_moderator   	  'users/:id/remove_moderator/:group',  		    :controller => 'users',    		    :action => 'remove_moderator'   
  map.petition              'users/:id/petition',                         :controller => 'users',           :action => 'petition'
  
  map.set_user_looking            'users/:id/set_looking',  	            :controller => 'users',    		    :action => 'set_looking'
  map.set_available               'users/:id/set_available',  		        :controller => 'users',    		    :action => 'set_available'
  map.set_private_phone           'users/:id/set_private_phone',  		    :controller => 'users',    		    :action => 'set_private_phone'
  map.set_private_profile         'users/:id/set_private_profile',  		  :controller => 'users',    		    :action => 'set_private_profile'
  map.set_enable_comments         'users/:id/set_enable_comments',  		  :controller => 'users',    		    :action => 'set_enable_comments'
  map.set_teammate_notification   'users/:id/set_teammate_notification',  :controller => 'users',    		    :action => 'set_teammate_notification'
  map.set_message_notification    'users/:id/set_message_notification',  	:controller => 'users',    		    :action => 'set_message_notification'
  map.set_blog_notification       'users/:id/set_blog_notification',  	  :controller => 'users',    	      :action => 'set_blog_notification'
  map.set_forum_notification      'users/:id/set_forum_notification',  	  :controller => 'users',    	      :action => 'set_forum_notification'
  
  map.third_party           'users/third_party',                          :controller => 'users',           :action => 'third_party'
  map.associate_return      'users/associate_return',                     :controller => 'users',           :action => 'associate_return'
    
  map.set_public            'schedules/:id/set_public',                   :controller => 'schedules',       :action => 'set_public'
  map.set_previous_profile  'schedules/:id/set_previous_profile',         :controller => 'schedules',       :action => 'set_previous_profile'
  map.set_reminder          'schedules/:id/set_reminder',                 :controller => 'schedules',       :action => 'set_reminder'
  
  map.set_group_enable_comments   'groups/:id/set_enable_comments',  		  :controller => 'groups',    		  :action => 'set_enable_comments'
  map.set_group_available         'groups/:id/set_available',  		        :controller => 'groups',    		  :action => 'set_available'
  map.set_group_looking           'groups/:id/set_looking',  	            :controller => 'groups',    		  :action => 'set_looking'
  
  
  map.match_team            'matches/:id/set_team',                       :controller => 'matches',         :action => 'set_team'
  map.match_status          'matches/:id/set_status/:type',               :controller => 'matches',         :action => 'set_status'
  
  map.reply_message         'messages/:id/reply',                         :controller => 'messages',        :action => 'reply'
  map.untrash_message       'messages/:id/undestroy',                     :controller => 'messages',        :action => 'undestroy'
         
  map.upcoming              'home/upcoming',                              :controller => 'home',            :action => 'upcoming'         
  
  map.archive_scorecard     'scorecards/:id/archive',                     :controller => 'scorecards',      :action => 'archive'
  map.show_archive          'scorecards/:id/show_archive',                :controller => 'scorecards',      :action => 'show_archive'
  
  map.ratings_rate          'ratings/:id/rate/:type',                     :controller => 'ratings',         :action => 'rate'
  
  map.import_contact        'invitations/contact',                        :controller => 'invitations',     :action => 'contact'
  map.invite_contact        'invitations/invite_contact',                 :controller => 'invitations',     :action => 'invite_contact'
  map.invite                'invitations/invite',                         :controller => 'invitations',     :action => 'invite'
  
  map.about                 'about',                                      :controller => 'home',            :action => 'about'
  map.terms_of_use          'terms_of_use',                               :controller => 'home',            :action => 'terms_of_use'
  map.privacy_policy        'privacy_policy',                             :controller => 'home',            :action => 'privacy_policy'
  map.faq                   'faq',                                        :controller => 'home',            :action => 'faq'
  map.openid                'openid',                                     :controller => 'home',            :action => 'openid'
  
  map.tour_list			        'tour_list',			                            :controller => 'tournaments',     :action => 'tour_list'
  map.tour_roster		        'tour_roster',		                            :controller => 'meets',           :action => 'tour_roster'
  map.tour_last_minute		  'tour_last_minute',		                        :controller => 'meets',           :action => 'tour_last_minute'
  map.tour_no_show		      'tour_no_show',			                          :controller => 'meets',           :action => 'tour_no_show'
  map.tour_unavailable      'tour_unavailable',			                      :controller => 'meets',           :action => 'tour_unavailable'
  
  map.clash_tour            'clashes/:id/set_tour',                       :controller => 'clashes',         :action => 'set_tour'
  map.clash_status          'clashes/:id/set_status/:type',               :controller => 'clashes',         :action => 'set_status'
  
  map.hide_announcements    '/hide_announcements',                        :controller => 'javascripts',     :action => 'hide_announcements'
  
  map.set_score             'games/:id/set_score',                        :controller => 'games',           :action => 'set_score'
  
  map.resources   :user_sessions,   :as => 'repitelo'
  map.resources   :users,           :as => 'jugadores',                   :collection => { :rpx_create => :post, :rpx_associate => :post, :list => :get, :recent_activity => :get, :search => :get }  
  map.resources   :schedules,       :as => 'eventos',                     :collection => { :list => :get, :archive_list => :get, :search => :get, :my_list => :get }          
  map.resources   :groups,          :as => 'equipos',                     :collection => { :list => :get, :search => :get }
  map.resources   :markers,         :as => 'centros'
  map.resources   :scorecards,      :as => 'classificaciones',            :collection => { :list => :get }

  map.resources   :matches,         :as => 'jornadas'
  map.resources   :invitations,     :as => 'invitaciones'
  map.resources   :activities,      :as => 'actividades'
  map.resources   :teammates,       :as => 'mi_equipo'

  map.resources   :comments,        :as => 'comentario'
  map.resources   :blogs,           :as => 'muro'
  map.resources   :forums,          :as => 'foro'
    
  map.resources   :types,           :as => 'tipos'
  map.resources   :sports,          :as => 'deportes'
  map.resources   :roles,           :as => 'responsabilidades'          
  map.resources   :payments,        :as => 'pago',                        :collection => { :list => :get }
  map.resources   :fees,            :as => 'tasas',                       :collection => { :item => :get, :list => :get, :complete => :get, :item_list => :get, :item_complete => :get} 
  map.resources   :password_resets, :as => 'resetear'
  map.resources   :messages,        :as => 'mensajes',                    :collection => { :sent => :get, :trash => :get }
  map.resources   :classifieds,     :as => 'anuncios',                    :collection => { :sent => :get, :trash => :get }
    
  map.resources   :standings,       :as => 'encasillado',                 :collection => { :list => :get, :show_list => :get, :show_all => :get }
    
  map.resources   :connections
  map.resources   :schedules,                                             :member => { :rate => :post }
  
  map.resources   :announcements,   :as => 'comunicaciones',              :collection => { :list => :get }
  
  map.resources   :cups,            :as => 'copas',                       :collection => { :list => :get }
  map.resources   :games,           :as => 'partidos',                    :collection => { :list => :get }
  map.resources   :challenges,                                            :collection => { :list => :get }
  map.resources   :casts,           :as => 'pronostico',                  :collection => { :list => :get, :list_guess => :get }
  map.resources   :escuadras
  
  map.resources   :users do |user|
    user.resources :messages
  end

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
  
  map.connect ":controller/:action.:format"
end