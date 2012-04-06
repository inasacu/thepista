Thepista::Application.routes.draw do

	root :to => "home#index" 
	
	match '/' => 'home#index'

	match 'rpx_token_sessions' => 'user_sessions#rpx_create', :as => :rpx_token_sessions

	match 'rpx_signup' => 'users#rpx_new', :as => :rpx_signup
	match 'rpx_create' => 'users#rpx_create', :as => :rpx_create
	match 'signup' => 'users#signup', :as => :signup

	match 'acceso_session' => 'user_sessions#new', :as => :login
	match 'cierra_session' => 'user_sessions#destroy', :as => :logout

	match 'configurar_idioma' => 'users#set_language', :as => :language

	match 'remove_openid' => 'users#remove_openid', :as => :remove_openid
	match 'my_openid' => 'users#third_party', :as => :my_openid

	match 'actividades_recientes' => 'users#recent_activity', :as => :recent_activity

	match 'jugadores_de_equipo' => 'groups#team_list', :as => :team_list

	match 'jornada_deportiva_convocado' => 'schedules#team_roster', :as => :team_roster
	match 'jornada_deportiva_ultima_hora' => 'schedules#team_last_minute', :as => :team_last_minute
	match 'jornada_deportiva_ausente' => 'schedules#team_no_show', :as => :team_no_show
	match 'jornada_deportiva_no_disponible' => 'schedules#team_unavailable', :as => :team_unavailable

	match 'eventos_equipo' => 'schedules#schedule_list', :as => :schedule_list
	match 'lista_marcadores' => 'markers#marker_list', :as => :marker_list
	match 'retos_copa' => 'challenges#challenge_list', :as => :challenge_list

	match 'mi_equipo/:id/unirse_equipo/:teammate' => 'teammates#join_team', :as => :join_team
	match 'mi_equipo/:id/dejar_equipo/:teammate' => 'teammates#leave_team', :as => :leave_team
	match 'mi_equipo/:id/acepta_unirse_equipo/' => 'teammates#join_team_accept', :as => :join_team_accept
	match 'mi_equipo/:id/deniega_unirse_equipo/' => 'teammates#join_team_decline', :as => :join_team_decline
	match 'mi_equipo/:id/unirse/:teammate' => 'teammates#join_item', :as => :join_item
	match 'mi_equipo/:id/dejar/:teammate' => 'teammates#leave_item', :as => :leave_item
	match 'mi_equipo/:id/acepta_unirse' => 'teammates#join_item_accept', :as => :join_item_accept
	match 'mi_equipo/:id/deniega_unirse' => 'teammates#join_item_decline', :as => :join_item_decline

	match 'jugadores/:id/marcar_manager/:group' => 'users#set_manager', :as => :set_manager
	match 'jugadores/:id/borrar_manager/:group' => 'users#remove_manager', :as => :remove_manager
	match 'jugadores/:id/marcar_sub_manager/:group' => 'users#set_sub_manager', :as => :set_sub_manager
	match 'jugadores/:id/borrar_sub_manager/:group' => 'users#remove_sub_manager', :as => :remove_sub_manager
	match 'jugadores/:id/marcar_subscripcion/:group' => 'users#set_subscription', :as => :set_subscription
	match 'jugadores/:id/borrar_subscripcion/:group' => 'users#remove_subscription', :as => :remove_subscription
	match 'jugadores/:id/marcar_moderador/:group' => 'users#set_moderator', :as => :set_moderator
	match 'jugadores/:id/borrar_moderador/:group' => 'users#remove_moderator', :as => :remove_moderator
	match 'jugadores/:id/peticiones_equipo' => 'users#petition', :as => :petition
	match 'jugadores/:id/buscar_equipo' => 'users#set_looking', :as => :set_user_looking
	match 'jugadores/:id/jugador_disponible' => 'users#set_available', :as => :set_available
	match 'jugadores/:id/ocultar_telefono' => 'users#set_private_phone', :as => :set_private_phone
	match 'jugadores/:id/ocultar_perfil' => 'users#set_private_profile', :as => :set_private_profile
	match 'jugadores/:id/habilitar_comentarios' => 'users#set_enable_comments', :as => :set_enable_comments
	match 'jugadores/:id/habilitar_notificaciones' => 'users#set_teammate_notification', :as => :set_teammate_notification
	match 'jugadores/:id/habilitar_mensajes' => 'users#set_message_notification', :as => :set_message_notification
	match 'jugadores/:id/habilitar_muro' => 'users#set_blog_notification', :as => :set_blog_notification
	match 'jugadores/:id/habilitar_foro' => 'users#set_forum_notification', :as => :set_forum_notification
	match 'jugadores/:id/habilitar_ultima_hora' => 'users#set_last_minute_notification', :as => :set_last_minute_notification
	match 'eventos/:id/marcar_como_publico' => 'schedules#set_public', :as => :set_public
	match 'eventos/:id/habilitar_perfil_previo' => 'schedules#set_previous_profile', :as => :set_previous_profile
	match 'eventos/:id/marcar_recordatorio' => 'schedules#set_reminder', :as => :set_reminder

	match 'eventos/:id/actual_evento' => 'schedules#group_current', :as => :group_current
	match 'eventos/:id/previo_evento' => 'schedules#group_previous', :as => :group_previous
	
	match 'equipos/:id/habilitar_comentarios_equipo' => 'groups#set_enable_comments', :as => :set_group_enable_comments
	match 'equipos/:id/equipo_disponible' => 'groups#set_available', :as => :set_group_available
	match 'equipos/:id/buscar_jugado' => 'groups#set_looking', :as => :set_group_looking

  match 'equipos/:id/unirse_automaticamente' => 'groups#set_group_auto', :as => :set_automatic_petition
  match 'retos_copa/:id/unirse_automaticamente' => 'challenges#set_challenge_auto',  :as => :set_automatic_petition

	match 'jornadas/:id/cambio_equipo' => 'matches#set_team', :as => :match_team
	match 'jornadas/:id/cambio_convocatoria/:type' => 'matches#set_status', :as => :match_status
	match 'jornadas/:id/cambio_convocatoria/:type/:block_token' => 'matches#set_status_link', :as => :match_token

	match 'mensajes/:id/responder' => 'messages#reply', :as => :reply_message
	match 'mensajes/:id/recuperar' => 'messages#undestroy', :as => :untrash_message

	match 'proximos_partidos' => 'home#upcoming', :as => :upcoming
	match 'buqueda' => 'home#search', :as => :search
	match 'comunicado' => 'home#advertisement', :as => :advertisement
	   
  match 'buscar_en_mapa' => 'markers#search_map', :as => :search
  match 'address_map' => 'markers#address_map', :as => :address
  
  match 'clasificacion/:id/archivar' => 'scorecards#archive_scorecard', :as => :archive
  match 'clasificacion/:id/mostrar_archivado' => 'scorecards#show_archive', :as => :show_archive
  
	match 'calificaciones/:id/calificacion/:type' => 'ratings#rate', :as => :ratings_rate

	match 'invitaciones/importar_contacto' => 'invitations#contact', :as => :import_contact
	match 'invitaciones/invita_contacto' => 'invitations#invite_contact', :as => :invite_contact
	match 'invitaciones/invita' => 'invitations#invite', :as => :invite

	match 'sobre' => 'home#about', :as => :about
	match 'terminos' => 'home#terms_of_use', :as => :terms_of_use
	match 'privacidad' => 'home#privacy_policy', :as => :privacy_policy
	match 'ayuda' => 'home#faq', :as => :faq
	match 'precios' => 'home#pricing', :as => :pricing
	match 'openid' => 'home#openid', :as => :openid
	match 'success' => 'home#success', :as => :success

	match '/ocultar_aviso' => 'javascripts#hide_announcements', :as => :hide_announcements

	match 'partidos/:id/poner_resultado' => 'games#set_score', :as => :set_score
	match 'jornadas/:id/habilitar_perfil' => 'matches#set_profile', :as => :set_profile
	match 'equipos/:id/valoracion' => 'matches#star_rate', :as => :star_rate
	match 'jornadas/:id/habilitar_perfil_jugador' => 'matches#set_user_profile', :as => :set_user_profile
	match 'encasillado/:id/fase_de_grupos' => 'standings#set_group_stage', :as => :set_group_stage

  match 'horario/:id/replica/:current_id' => 'timetables#set_copy_timetable', :as => :set_copy_timetable
  
  match 'festivo/:venue_id/abierto/:block_token' => 'holidays#set_holiday_open', :as => :set_holiday_open
  match 'festivo/:venue_id/cerrado/:block_token' => 'holidays#set_holiday_closed', :as => :set_holiday_closed
  match 'festivo/:venue_id/nada/:block_token'=> 'holidays#set_holiday_none', :as => :set_holiday_none


	resources :user_sessions
	resources :users do
		collection do
			post :rpx_create
			# post :rpx_associate
			get :list
			get :recent_activity
			get :notice
		end
	end

	resources :schedules do
		collection do
			get :list
			get :archive_list
			get :my_list
		end
	end

	resources :groups do
		collection do
			get :list
		end  
	end

	resources :markers
	resources :scorecards do
		collection do
			get :list
		end  
	end

	resources :matches
	resources :invitations
	resources :teammates
	resources :comments
	resources :blogs
	resources :forums
	resources :types
	resources :sports
	resources :roles
	resources :workers
	
	
	
	resources :payments do
		collection do
			get :list
		end 
	end

	resources :fees do
		collection do
			get :list
			get :item
			get :due
		end
	end

	resources :password_resets
	resources :messages do
		collection do
			get :sent
			get :trash
		end
	end

	resources :classifieds do
		collection do
			get :sent
			get :trash
		end
	end

	resources :standings do
		collection do
			get :list
			get :show_list
			get :show_all
		end
	end

	resources :connections
	resources :announcements do
		collection do
			get :list
		end
	end

	resources :cups do
		collection do
			get :list
		end
	end

	resources :games do
		collection do
			get :list
		end
	end

	resources :challenges do
		collection do
			get :list
		end
	end

	resources :casts do
		collection do
			get :list
			get :list_guess
		end
	end

	resources :escuadras
	resources :venues do
		collection do
			get :list
		end
	end

	resources :installations do
		collection do
			get :list
		end
	end

	resources :reservations do
		collection do
			get :list
		end
	end

	resources :purchases
	resources :users do
		resources :messages
	end

	resources :users do  
		member do
			post :rate
		end  
	end

	resources :matches do  
		member do
			post :rate
		end  
	end

	resources :schedules do
		member do
			post :rate
		end  
	end

	match ':controller/:action.:format' => '#index'
	
	#   map.language              'configurar_idioma',                          :controller => 'users',           :action => 'set_language'
	#   map.remove_openid         'remove_openid',                              :controller => 'users',           :action => 'remove_openid'
	#   map.my_openid			        'my_openid',			                            :controller => 'users',           :action => 'third_party'
	# 
	#   map.recent_activity       'actividades_recientes',                      :controller => 'users',           :action => 'recent_activity'
	#   map.team_list			        'jugadores_de_equipo',                        :controller => 'groups',          :action => 'team_list'
	#   map.team_roster		        'jornada_deportiva_convocado',                :controller => 'schedules',       :action => 'team_roster'
	#   map.team_last_minute		  'jornada_deportiva_ultima_hora',	            :controller => 'schedules',       :action => 'team_last_minute'
	#   map.team_no_show		      'jornada_deportiva_ausente',			            :controller => 'schedules',       :action => 'team_no_show'
	#   map.team_unavailable      'jornada_deportiva_no_disponible',            :controller => 'schedules',       :action => 'team_unavailable'
	#   map.schedule_list	        'eventos_equipo',			                        :controller => 'schedules',       :action => 'schedule_list'
	#   map.marker_list		        'lista_marcadores',			                      :controller => 'markers',         :action => 'marker_list'
	#   map.challenge_list			  'retos_copa',			                            :controller => 'challenges',      :action => 'challenge_list'
	# 
	#   map.join_team   			    'mi_equipo/:id/unirse_equipo/:teammate',    	:controller => 'teammates',       :action => 'join_team'
	#   map.leave_team		  	    'mi_equipo/:id/dejar_equipo/:teammate',    	  :controller => 'teammates',       :action => 'leave_team'
	#   map.join_team_accept	    'mi_equipo/:id/acepta_unirse_equipo/',        :controller => 'teammates',       :action => 'join_team_accept'
	#   map.join_team_decline	    'mi_equipo/:id/deniega_unirse_equipo/',       :controller => 'teammates',       :action => 'join_team_decline' 
	#    
	#   map.join_item   			    'mi_equipo/:id/unirse/:teammate',    	        :controller => 'teammates',       :action => 'join_item'
	#   map.leave_item		  	    'mi_equipo/:id/dejar/:teammate',    	        :controller => 'teammates',       :action => 'leave_item'
	#   map.join_item_accept	    'mi_equipo/:id/acepta_unirse',                :controller => 'teammates',       :action => 'join_item_accept'
	#   map.join_item_decline	    'mi_equipo/:id/deniega_unirse',               :controller => 'teammates',       :action => 'join_item_decline'
	#   map.set_manager     	    'jugadores/:id/marcar_manager/:group',    		:controller => 'users',    		    :action => 'set_manager'
	#   map.remove_manager  	    'jugadores/:id/borrar_manager/:group', 		    :controller => 'users',     	    :action => 'remove_manager'
	#   map.set_sub_manager     	'jugadores/:id/marcar_sub_manager/:group',    :controller => 'users',    		    :action => 'set_sub_manager'
	#   map.remove_sub_manager  	'jugadores/:id/borrar_sub_manager/:group', 		:controller => 'users',     	    :action => 'remove_sub_manager'
	#   map.set_subscription   	  'jugadores/:id/marcar_subscripcion/:group',   :controller => 'users',    		    :action => 'set_subscription'
	#   map.remove_subscription   'jugadores/:id/borrar_subscripcion/:group',  	:controller => 'users',    		    :action => 'remove_subscription' 
	#   map.set_moderator   		  'jugadores/:id/marcar_moderador/:group',    	:controller => 'users',    		    :action => 'set_moderator'
	#   map.remove_moderator   	  'jugadores/:id/borrar_moderador/:group',  		:controller => 'users',    		    :action => 'remove_moderator'   
	#   map.petition              'jugadores/:id/peticiones_equipo',            :controller => 'users',           :action => 'petition'
	#   map.set_user_looking                'jugadores/:id/buscar_equipo',  	            :controller => 'users',    		    :action => 'set_looking'
	#   map.set_available                   'jugadores/:id/jugador_disponible',  		      :controller => 'users',    		    :action => 'set_available'
	#   map.set_private_phone               'jugadores/:id/ocultar_telefono',  		        :controller => 'users',    		    :action => 'set_private_phone'
	#   map.set_private_profile             'jugadores/:id/ocultar_perfil',  		          :controller => 'users',    		    :action => 'set_private_profile'
	#   map.set_enable_comments             'jugadores/:id/habilitar_comentarios',  		  :controller => 'users',    		    :action => 'set_enable_comments'
	#   map.set_teammate_notification       'jugadores/:id/habilitar_notificaciones',     :controller => 'users',    		    :action => 'set_teammate_notification'
	#   map.set_message_notification        'jugadores/:id/habilitar_mensajes',  	        :controller => 'users',    		    :action => 'set_message_notification'
	#   map.set_blog_notification           'jugadores/:id/habilitar_muro',  	            :controller => 'users',    	      :action => 'set_blog_notification'
	#   map.set_forum_notification          'jugadores/:id/habilitar_foro',  	            :controller => 'users',    	      :action => 'set_forum_notification'
	#   map.set_last_minute_notification    'jugadores/:id/habilitar_ultima_hora',  	    :controller => 'users',    	      :action => 'set_last_minute_notification'
	#     
	#   map.third_party           'jugadores/third_party',                      :controller => 'users',           :action => 'third_party'
	#   map.associate_return      'jugadores/associate_return',                 :controller => 'users',           :action => 'associate_return'
	#     
	#   map.set_public            'eventos/:id/marcar_como_publico',            :controller => 'schedules',       :action => 'set_public'
	#   map.set_previous_profile  'eventos/:id/habilitar_perfil_previo',        :controller => 'schedules',       :action => 'set_previous_profile'
	#   map.set_reminder          'eventos/:id/marcar_recordatorio',            :controller => 'schedules',       :action => 'set_reminder'
	#   map.group_current         'eventos/:id/actual_evento',                  :controller => 'schedules',       :action => 'group_current_list'
	#   map.group_previous        'eventos/:id/previo_evento',                  :controller => 'schedules',       :action => 'group_previous_list'
	#   map.set_group_enable_comments   'equipos/:id/habilitar_comentarios_equipo',   :controller => 'groups',    		  :action => 'set_enable_comments'
	#   map.set_group_available         'equipos/:id/equipo_disponible',  		        :controller => 'groups',    		  :action => 'set_available'
	#   map.set_group_looking           'equipos/:id/buscar_jugado',  	              :controller => 'groups',    		  :action => 'set_looking' 
	#   map.set_group_auto       'equipos/:id/unirse_automaticamente',     :controller => 'groups',          :action => 'set_automatic_petition' 
	#   map.set_challenge_auto   'retos_copa/:id/unirse_automaticamente',  :controller => 'challenges',      :action => 'set_automatic_petition'
	#   map.match_team            'jornadas/:id/cambio_equipo',                             :controller => 'matches',         :action => 'set_team'
	#   map.match_status          'jornadas/:id/cambio_convocatoria/:type',                 :controller => 'matches',         :action => 'set_status'
	#   map.match_token           'jornadas/:id/cambio_convocatoria/:type/:block_token',    :controller => 'matches',         :action => 'set_status_link'
	#   map.reply_message         'mensajes/:id/responder',                           :controller => 'messages',        :action => 'reply'
	#   map.untrash_message       'mensajes/:id/recuperar',                           :controller => 'messages',        :action => 'undestroy'
	#          
	#   map.upcoming              'proximos_partidos',                                :controller => 'home',            :action => 'upcoming'         
	#   map.search                'busqueda',                                         :controller => 'home',            :action => 'search'
	#   map.advertisement         'comunicado',                                       :controller => 'home',            :action => 'advertisement'
	#      
	#   map.search_map            'buscar_en_mapa',                                   :controller => 'markers',         :action => 'search'
	#   map.address_map           'address_map',                                      :controller => 'markers',         :action => 'address'
	#   map.archive_scorecard     'clasificacion/:id/archivar',                       :controller => 'scorecards',      :action => 'archive'
	#   map.show_archive          'clasificacion/:id/mostrar_archivado',              :controller => 'scorecards',      :action => 'show_archive'
	#   map.ratings_rate          'calificaciones/:id/calificacion/:type',                         :controller => 'ratings',         :action => 'rate'
	#   map.import_contact        'invitaciones/importar_contacto',                   :controller => 'invitations',     :action => 'contact'
	#   map.invite_contact        'invitaciones/invita_contacto',                     :controller => 'invitations',     :action => 'invite_contact'
	#   map.invite                'invitaciones/invita',                              :controller => 'invitations',     :action => 'invite'
	#   map.about                 'sobre',                                            :controller => 'home',            :action => 'about'
	#   map.terms_of_use          'terminos',                                         :controller => 'home',            :action => 'terms_of_use'
	#   map.privacy_policy        'privacidad',                                       :controller => 'home',            :action => 'privacy_policy'
	#   map.faq                   'ayuda',                                            :controller => 'home',            :action => 'faq'
	#   map.pricing               'precios',                                          :controller => 'home',            :action => 'pricing'
	#   map.openid                'openid',                                           :controller => 'home',            :action => 'openid'
	#   map.success               'success',                                          :controller => 'home',            :action => 'success'
	#   map.hide_announcements    '/ocultar_aviso',                                   :controller => 'javascripts',     :action => 'hide_announcements'
	#   map.set_score             'partidos/:id/poner_resultado',                     :controller => 'games',           :action => 'set_score'
	#   map.set_profile           'jornadas/:id/habilitar_perfil',                    :controller => 'matches',         :action => 'set_profile'
	#   map.star_rate             'equipos/:id/valoracion',                           :controller => 'matches',         :action => 'star_rate'
	#   map.set_user_profile      'jornadas/:id/habilitar_perfil_jugador',            :controller => 'matches',         :action => 'set_user_profile'
	#   map.set_group_stage       'encasillado/:id/fase_de_grupos',                   :controller => 'standings',       :action => 'set_group_stage'
	#   map.set_copy_timetable    'horario/:id/replica/:current_id',                  :controller => 'timetables',      :action => 'set_copy_timetable'
	#   map.set_holiday_open      'festivo/:venue_id/abierto/:block_token',           :controller => 'holidays',        :action => 'set_holiday_open'  
	#   map.set_holiday_closed    'festivo/:venue_id/cerrado/:block_token',           :controller => 'holidays',        :action => 'set_holiday_closed'  
	#   map.set_holiday_none      'festivo/:venue_id/nada/:block_token',              :controller => 'holidays',        :action => 'set_holiday_none'
	#   map.resources   :user_sessions,   :as => 'repitelo'
	#   map.resources   :users,           :as => 'jugadores',                   :collection => { :rpx_create => :post, :rpx_associate => :post, :list => :get, 
	#                                                                                            :recent_activity => :get, :notice => :get }  
	#   map.resources   :schedules,       :as => 'eventos',                     :collection => { :list => :get, :archive_list => :get, :my_list => :get }          
	#   map.resources   :groups,          :as => 'equipos',                     :collection => { :list => :get }
	#   map.resources   :markers,         :as => 'mapa',                        :collection => { :list => :get , :direction => :get, :full_list => :get}
	#   map.resources   :scorecards,      :as => 'clasificaciones',            :collection => { :list => :get }
	# 
	#   map.resources   :matches,         :as => 'jornadas'
	#   map.resources   :invitations,     :as => 'invitaciones'
	#   map.resources   :teammates,       :as => 'mi_equipo'
	# 
	#   map.resources   :comments,        :as => 'comentario'
	#   map.resources   :blogs,           :as => 'muro'
	#   map.resources   :forums,          :as => 'muro_evento'
	#     
	#   map.resources   :types,           :as => 'tipos'
	#   map.resources   :sports,          :as => 'deportes'
	#   map.resources   :roles,           :as => 'responsabilidades'          
	#   map.resources   :payments,        :as => 'pago',                        :collection => { :list => :get }
	#   map.resources   :fees,            :as => 'tasas',                       :collection => { :list => :get, :item => :get, :due => :get } 
	#   map.resources   :password_resets, :as => 'resetear'
	#   map.resources   :messages,        :as => 'mensajes',                    :collection => { :sent => :get, :trash => :get }
	#   map.resources   :classifieds,     :as => 'anuncios',                    :collection => { :sent => :get, :trash => :get }
	#     
	#   map.resources   :standings,       :as => 'encasillado',                 :collection => { :list => :get, :show_list => :get, :show_all => :get }
	#     
	#   map.resources   :connections
	#   map.resources   :announcements,   :as => 'comunicaciones',              :collection => { :list => :get }
	#   map.resources   :cups,            :as => 'copas',                       :collection => { :list => :get }
	#   map.resources   :games,           :as => 'partidos',                    :collection => { :list => :get }
	#   map.resources   :challenges,                                            :collection => { :list => :get }
	#   map.resources   :casts,           :as => 'pronosticos',                 :collection => { :list => :get, :list_guess => :get }
	#   map.resources   :escuadras
	#   map.resources   :venues,          :as => 'centros_deportivos',          :collection => { :list => :get }
	#   map.resources   :installations,   :as => 'instalaciones',               :collection => { :list => :get }
	#   map.resources   :reservations,    :as => 'reservas',                    :collection => { :list => :get }
	#   map.resources   :auth,            :as => 'opensocial'
	#   map.resources   :timetables,      :as => 'horario'
	#   map.resources   :holidays,        :as => 'festivo'
	#   map.resources   :users do |user|
	#     user.resources :messages
	#   end
	#   map.resources :users, :member => {:rate => :post}
	#   map.resources :matches, :member => {:rate => :post}
	#   map.resources :schedules, :member => {:rate => :post}



end
