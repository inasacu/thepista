ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'
  
  # rpxnow implementation
  map.rpx_token_sessions    'rpx_token_sessions',                         :controller => "user_sessions",   :action => "rpx_create"
  map.rpx_signup            '/rpx_signup',                                :controller => 'users',           :action => 'rpx_new'
  map.rpx_create            'users/rpx_create',                           :controller => 'users',           :action => 'rpx_create'
  map.signup                'signup',                                     :controller => 'users',           :action => 'signup'
  
  map.login                 'acceso_session',                             :controller => 'user_sessions',   :action => 'new'
  map.logout                'cierra_session',                             :controller => 'user_sessions',   :action => 'destroy'
  
  map.language              'configurar_idioma',                          :controller => 'users',           :action => 'set_language'
  
  map.remove_openid         'remove_openid',                              :controller => 'users',           :action => 'remove_openid'
  map.my_openid			        'my_openid',			                            :controller => 'users',           :action => 'third_party'

  map.recent_activity       'actividades_recientes',                      :controller => 'users',           :action => 'recent_activity'
  
  map.team_list			        'jugadores_de_equipo',                        :controller => 'groups',          :action => 'team_list'
  map.team_roster		        'jornada_deportiva_convocado',                :controller => 'schedules',       :action => 'team_roster'
  map.team_last_minute		  'jornada_deportiva_ultima_hora',	            :controller => 'schedules',       :action => 'team_last_minute'
  map.team_no_show		      'jornada_deportiva_ausente',			            :controller => 'schedules',       :action => 'team_no_show'
  map.team_unavailable      'jornada_deportiva_no_disponible',            :controller => 'schedules',       :action => 'team_unavailable'
  
  map.schedule_list	        'eventos_equipo',			                        :controller => 'schedules',       :action => 'schedule_list'
  map.marker_list		        'lista_marcadores',			                      :controller => 'markers',         :action => 'marker_list'
  map.challenge_list			  'retos_copa',			                            :controller => 'challenges',      :action => 'challenge_list'

  map.join_team   			    'mi_equipo/:id/unirse_equipo/:teammate',    	:controller => 'teammates',       :action => 'join_team'
  map.leave_team		  	    'mi_equipo/:id/dejar_equipo/:teammate',    	:controller => 'teammates',       :action => 'leave_team'
  map.join_team_accept	    'mi_equipo/:id/acepta_unirse_equipo/',       :controller => 'teammates',       :action => 'join_team_accept'
  map.join_team_decline	    'mi_equipo/:id/deniega_unirse_equipo/',      :controller => 'teammates',       :action => 'join_team_decline' 
   
  map.join_item   			    'mi_equipo/:id/unirse/:teammate',    	      :controller => 'teammates',       :action => 'join_item'
  map.leave_item		  	    'mi_equipo/:id/dejar/:teammate',    	        :controller => 'teammates',       :action => 'leave_item'
  map.join_item_accept	    'mi_equipo/:id/acepta_unirse',               :controller => 'teammates',       :action => 'join_item_accept'
  map.join_item_decline	    'mi_equipo/:id/deniega_unirse',              :controller => 'teammates',       :action => 'join_item_decline'
  
  map.set_manager     	    'jugadores/:id/marcar_manager/:group',    		:controller => 'users',    		    :action => 'set_manager'
  map.remove_manager  	    'jugadores/:id/borrar_manager/:group', 		    :controller => 'users',     	    :action => 'remove_manager'
  map.set_sub_manager     	'jugadores/:id/marcar_sub_manager/:group',    :controller => 'users',    		    :action => 'set_sub_manager'
  map.remove_sub_manager  	'jugadores/:id/borrar_sub_manager/:group', 		:controller => 'users',     	    :action => 'remove_sub_manager'
  map.set_subscription   	  'jugadores/:id/marcar_subscripcion/:group',   :controller => 'users',    		    :action => 'set_subscription'
  map.remove_subscription   'jugadores/:id/borrar_subscripcion/:group',  	:controller => 'users',    		    :action => 'remove_subscription' 
  map.set_moderator   		  'jugadores/:id/marcar_moderador/:group',    	:controller => 'users',    		    :action => 'set_moderator'
  map.remove_moderator   	  'jugadores/:id/borrar_moderador/:group',  		:controller => 'users',    		    :action => 'remove_moderator'   
  map.petition              'jugadores/:id/peticiones_equipo',            :controller => 'users',           :action => 'petition'
  
  map.set_user_looking            'jugadores/:id/buscar_equipo',  	            :controller => 'users',    		    :action => 'set_looking'
  map.set_available               'jugadores/:id/jugador_disponible',  		      :controller => 'users',    		    :action => 'set_available'
  map.set_private_phone           'jugadores/:id/ocultar_telefono',  		        :controller => 'users',    		    :action => 'set_private_phone'
  map.set_private_profile         'jugadores/:id/ocultar_perfil',  		          :controller => 'users',    		    :action => 'set_private_profile'
  map.set_enable_comments         'jugadores/:id/habilitar_comentarios',  		  :controller => 'users',    		    :action => 'set_enable_comments'
  map.set_teammate_notification   'jugadores/:id/habilitar_notificaciones',     :controller => 'users',    		    :action => 'set_teammate_notification'
  map.set_message_notification    'jugadores/:id/habilitar_mensajes',  	        :controller => 'users',    		    :action => 'set_message_notification'
  map.set_blog_notification       'jugadores/:id/habilitar_muro',  	            :controller => 'users',    	      :action => 'set_blog_notification'
  map.set_forum_notification      'jugadores/:id/habilitar_foro',  	            :controller => 'users',    	      :action => 'set_forum_notification'
  
  map.third_party           'jugadores/third_party',                            :controller => 'users',           :action => 'third_party'
  map.associate_return      'jugadores/associate_return',                       :controller => 'users',           :action => 'associate_return'
    
  map.set_public            'eventos/:id/marcar_como_publico',                  :controller => 'schedules',       :action => 'set_public'
  map.set_previous_profile  'eventos/:id/habilitar_perfil_previo',              :controller => 'schedules',       :action => 'set_previous_profile'
  map.set_reminder          'eventos/:id/marcar_recordatorio',                  :controller => 'schedules',       :action => 'set_reminder'
  
  map.group_current         'eventos/:id/actual_evento',                        :controller => 'schedules',       :action => 'group_current_list'
  map.group_previous        'eventos/:id/previo_evento',                        :controller => 'schedules',       :action => 'group_previous_list'
  
  
  map.set_group_enable_comments   'equipos/:id/habilitar_comentarios_equipo',   :controller => 'groups',    		  :action => 'set_enable_comments'
  map.set_group_available         'equipos/:id/equipo_disponible',  		        :controller => 'groups',    		  :action => 'set_available'
  map.set_group_looking           'equipos/:id/buscar_jugado',  	              :controller => 'groups',    		  :action => 'set_looking'  
  
  map.match_team            'jornadas/:id/cambio_equipo',                       :controller => 'matches',         :action => 'set_team'
  map.match_status          'jornadas/:id/cambio_convocatoria/:type',                 :controller => 'matches',         :action => 'set_status'
  map.match_token           'jornadas/:id/cambio_convocatoria/:type/:block_token',    :controller => 'matches',         :action => 'set_status_link'
  
  map.reply_message         'mensajes/:id/responder',                           :controller => 'messages',        :action => 'reply'
  map.untrash_message       'mensajes/:id/recuperar',                           :controller => 'messages',        :action => 'undestroy'
         
  map.upcoming              'proximos_partidos',                                :controller => 'home',            :action => 'upcoming'         
  map.search                'buqueda',                                          :controller => 'home',            :action => 'search'
  
  map.archive_scorecard     'clasificacion/:id/archivar',                       :controller => 'scorecards',      :action => 'archive'
  map.show_archive          'clasificacion/:id/mostrar_archivado',              :controller => 'scorecards',      :action => 'show_archive'
  
  map.ratings_rate          'calificaciones/:id/calificacion/:type',                         :controller => 'ratings',         :action => 'rate'
  
  map.import_contact        'invitaciones/importar_contacto',                    :controller => 'invitations',     :action => 'contact'
  map.invite_contact        'invitaciones/invita_contacto',                      :controller => 'invitations',     :action => 'invite_contact'
  map.invite                'invitaciones/invita',                               :controller => 'invitations',     :action => 'invite'
  
  map.about                 'sobre',                                            :controller => 'home',            :action => 'about'
  map.terms_of_use          'terminos',                                         :controller => 'home',            :action => 'terms_of_use'
  map.privacy_policy        'privacidad',                                       :controller => 'home',            :action => 'privacy_policy'
  map.faq                   'ayuda',                                            :controller => 'home',            :action => 'faq'
  map.pricing               'precios',                                          :controller => 'home',            :action => 'pricing'
  map.openid                'openid',                                           :controller => 'home',            :action => 'openid'
  map.success               'success',                                         :controller => 'home',            :action => 'success'
  
  map.hide_announcements    '/ocultar_aviso',                                   :controller => 'javascripts',     :action => 'hide_announcements'
  
  map.set_score             'partidos/:id/poner_resultado',                     :controller => 'games',           :action => 'set_score'
  map.set_profile           'jornadas/:id/habilitar_perfil',                    :controller => 'matches',         :action => 'set_profile'
  map.star_rate             'equipos/:id/valoracion',                           :controller => 'matches',         :action => 'star_rate'
  map.set_user_profile      'jornadas/:id/habilitar_perfil_jugador',            :controller => 'matches',         :action => 'set_user_profile'
  map.set_group_stage       'encasillado/:id/fase_de_grupos',                   :controller => 'standings',       :action => 'set_group_stage'
  
  map.resources   :user_sessions,   :as => 'repitelo'
  map.resources   :users,           :as => 'jugadores',                   :collection => { :rpx_create => :post, :rpx_associate => :post, :list => :get, :recent_activity => :get }  
  map.resources   :schedules,       :as => 'eventos',                     :collection => { :list => :get, :archive_list => :get, :my_list => :get }          
  map.resources   :groups,          :as => 'equipos',                     :collection => { :list => :get }
  map.resources   :markers,         :as => 'ubicaciones'
  map.resources   :scorecards,      :as => 'classificaciones',            :collection => { :list => :get }

  map.resources   :matches,         :as => 'jornadas'
  map.resources   :invitations,     :as => 'invitaciones'
  map.resources   :teammates,       :as => 'mi_equipo'

  map.resources   :comments,        :as => 'comentario'
  map.resources   :blogs,           :as => 'muro'
  map.resources   :forums,          :as => 'muro_evento'
    
  map.resources   :types,           :as => 'tipos'
  map.resources   :sports,          :as => 'deportes'
  map.resources   :roles,           :as => 'responsabilidades'          
  map.resources   :payments,        :as => 'pago',                        :collection => { :list => :get }
  map.resources   :fees,            :as => 'tasas',                       :collection => { :list => :get, :item => :get, :due => :get } 
  map.resources   :password_resets, :as => 'resetear'
  map.resources   :messages,        :as => 'mensajes',                    :collection => { :sent => :get, :trash => :get }
  map.resources   :classifieds,     :as => 'anuncios',                    :collection => { :sent => :get, :trash => :get }
    
  map.resources   :standings,       :as => 'encasillado',                 :collection => { :list => :get, :show_list => :get, :show_all => :get }
    
  map.resources   :connections
  
  map.resources   :announcements,   :as => 'comunicaciones',              :collection => { :list => :get }
  
  map.resources   :cups,            :as => 'copas',                       :collection => { :list => :get }
  map.resources   :games,           :as => 'partidos',                    :collection => { :list => :get }
  map.resources   :challenges,                                            :collection => { :list => :get }
  map.resources   :casts,           :as => 'pronosticos',                 :collection => { :list => :get, :list_guess => :get }
  map.resources   :escuadras
  
  map.resources   :venues,          :as => 'centros_deportivos',          :collection => { :list => :get }
  map.resources   :installations,   :as => 'instalaciones',               :collection => { :list => :get }
  map.resources   :reservations,    :as => 'reservas',                    :collection => { :list => :get }
  
  map.resources   :users do |user|
    user.resources :messages
  end
  
  map.resources :users, :member => {:rate => :post}
  map.resources :matches, :member => {:rate => :post}
  map.resources :schedules, :member => {:rate => :post}
  
  map.connect ":controller/:action.:format"
end