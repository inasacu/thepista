Thepista::Application.routes.draw do

	root :to => "home#index" 	
	match '/' => 'home#index'
	match 'qr' => 'home#index'
	
	# Enchufados widget
  match "/widget/", :to => 'widget#index'
  match "/widget/home", :to => 'widget#home', :as => :widget_home
  
  match "/widget/login/popup", :to => 'widget#login_check'
  match "/widget/check_omniauth", :to => 'widget#check_omniauth', :as => :widget_check_omniauth
  match '/widget/logout' => 'user_sessions#destroy_widget', :as => :widget_logout
  match "/widget/signup", :to => 'widget#signup', :as => :widget_signup
    
  match "/widget/do_apuntate", :to => 'widget#do_apuntate', :as => :widget_do_apuntate
  match "/widget/:matchid/change_user_state/:newstate", :to => 'widget#change_user_state', :as => :widget_change_user_state
  match '/widget/:matchid/change_team' => 'widget#set_team', :as => :widget_set_team
  
  match "/widget/event/:event_id", :to => 'widget#event_details', :as => :widget_event_details
  match "/widget/event/:event_id/noshow", :to => 'widget#event_details_noshow', :as => :widget_event_details_noshow
  match "/widget/event/:event_id/lastminute", :to => 'widget#event_details_lastminute', :as => :widget_event_details_lastminute
  
  match "/widget/event/:event_id/invitation", :to => 'widget#event_invitation', :as => :widget_event_invitation
  
  # ------------------------>
  
  # Mobile apps
  
  namespace :mobile do
    resources :security do
      collection do
        #get "other_action/:id", :to => "security#other_action"
      end
    end
    resources :user do
      collection do
      	post "register", :to => "user#user_registration"
      end
    end
    resources :event do
      collection do
        get "active_by_user/:user_id", :to => "event#active_events_by_user" 
        get "active_by_user_groups/:user_id", :to => "event#active_events_by_user_groups"
        get "by_id/:event_id", :to => "event#event_by_id"
        get "user_data/:event_id/:user_id", :to => "event#get_user_event_data"
        get "get_info/:event_id/:user_id", :to => "event#get_info_related_to_user"
        post "change_user_state", :to => "event#change_user_event_state"
        post "create_new", :to => "event#create_event"
      end
    end
    resources :group do
      collection do
        get "by_user/:user_id", :to => "group#groups_by_user"
        get "get_info/:group_id/:user_id", :to => "group#get_info_related_to_user"
        get "starred", :to => "group#starred_groups"
        post "create_new", :to => "group#create_group"
        post "add_member", :to => "group#add_member"
      end
    end
    resources :venue do
      collection do
        get "starred", :to => "venue#starred_venues"
      end
    end
    resources :util do
      collection do
        get "cities", :to => "util#get_cities"
        get "sports", :to => "util#get_sports"
      end
    end
  end
  
  
  # ------------------------>
  

  # match 'rpx_token_sessions' => 'user_sessions#rpx_create', :as => :rpx_token_sessions
  # match 'rpx_signup' => 'users#rpx_new', :as => :rpx_signup
  # match 'rpx_create' => 'users#rpx_create', :as => :rpx_create

	match 'omniauth_new' => 'users#omniauth_new', :as => :provider 

	match '/auth/:provider/callback' => 'authentications#create', :as => :callback
	match '/auth/failure' => 'authentications#failure', :as => :failure
	match '/failure' => 'authentications#failure', :as => :post_failure
	match '/auth/:provider' => 'authentications#blank', :as => :blank


	match 'registrate' => 'users#signup', :as => :signup
	match 'acceso_session' => 'user_sessions#new', :as => :login
	match 'cierra_session' => 'user_sessions#destroy', :as => :logout
	match 'activa_session' => 'users#activate_session', :as => :activate_session

  match 'confirmacion/:token' => 'users#confirmation', :as => :confirmation_token
	match 'configurar_idioma' => 'users#set_language', :as => :language
	match 'jugadores_de_equipo' => 'groups#team_list', :as => :team_list

	match 'evento_deportivo_convocado' => 'schedules#team_roster', :as => :team_roster
	match 'evento_deportivo_ultima_hora' => 'schedules#team_last_minute', :as => :team_last_minute
	match 'evento_deportivo_ausente' => 'schedules#team_no_show', :as => :team_no_show

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
	match 'jugadores/:id/peticiones_equipo' => 'users#petition', :as => :petition
	match 'jugadores/:id/ocultar_telefono' => 'users#set_private_phone', :as => :set_private_phone
	match 'jugadores/:id/ocultar_perfil' => 'users#set_private_profile', :as => :set_private_profile	
	match 'jugadores/:id/habilitar_notificaciones' => 'users#set_teammate_notification', :as => :set_teammate_notification
	match 'jugadores/:id/habilitar_mensajes' => 'users#set_message_notification', :as => :set_message_notification	
	match 'jugadores/:id/habilitar_ultima_hora' => 'users#set_last_minute_notification', :as => :set_last_minute_notification
	match 'jugadores/:id/utilizo_whatsapp' => 'users#set_whatsapp', :as => :set_whatsapp

	match 'eventos/:id/marcar_como_publico' => 'schedules#set_public', :as => :set_public
	match 'eventos/:id/habilitar_perfil_previo' => 'schedules#set_previous_profile', :as => :set_previous_profile
	match 'eventos/:id/marcar_recordatorio' => 'schedules#set_reminder', :as => :set_reminder
	match 'eventos/:id/actual_evento' => 'schedules#group_current', :as => :group_current
	match 'eventos/:id/previo_evento' => 'schedules#group_previous', :as => :group_previous

	match 'equipos/:id/unirse_automaticamente' => 'groups#set_automatic_petition', :as => :set_automatic_petition
	match 'equipos/:id/marcar_subscripcion/:venue' => 'groups#set_subscription', :as => :set_group_subscription
	match 'equipos/:id/borrar_subscripcion/:venue' => 'groups#remove_subscription', :as => :remove_group_subscription

	match 'retos_copa/:id/unirse_auto_reto' => 'challenges#set_auto_petition_challenge',  :as => :set_auto_petition_challenge

	match 'retos_copa/:id/marcar_reto_subscripcion/:challenge' => 'challenges#set_challenge_subscription', :as => :set_challenge_subscription
	match 'retos_copa/:id/borrar_reto_subscripcion/:challenge' => 'challenges#remove_challenge_subscription', :as => :remove_challenge_subscription

	match 'jornadas/:id/cambio_equipo' => 'matches#set_team', :as => :match_team
	match 'jornadas/:id/cambio_convocatoria/:type' => 'matches#set_status', :as => :match_status
	match 'jornadas/:id/cambio_convocatoria/:type/:block_token' => 'matches#set_status_link', :as => :match_token

	match 'mensajes/responder/:block_token' => 'messages#reply', :as => :reply_message
	match 'mensajes/borrar/:block_token' => 'messages#trash', :as => :trash_message

	match 'eventos_deportivos' => 'home#upcoming', :as => :upcoming
	match 'buqueda' => 'home#search', :as => :search
	match 'comunicado' => 'home#advertisement', :as => :advertisement
	match 'widget' => 'home#widget', :as => :widget

	match 'buscar_en_mapa' => 'markers#search_map', :as => :search
	match 'address_map' => 'markers#address_map', :as => :address

	match 'sobre' => 'home#about', :as => :about
	match 'terminos' => 'home#terms_of_use', :as => :terms_of_use
	match 'privacidad' => 'home#privacy_policy', :as => :privacy_policy
	match 'ayuda' => 'home#faq', :as => :faq
	match 'success' => 'home#success', :as => :success
	match 'persona' => 'home#persona', :as => :persona
	match 'feedback' => 'home#feedback', :as => :feedback
	match 'how_it_works' => 'home#how_it_works', :as => :how_it_works
	match 'for_websites' => 'home#for_websites', :as => :for_websites
	match 'launch' => 'home#launch', :as => :launch
	
	match 'companies/:id/personalize' => 'companies#personalize', :as => :personalize

	match '/ocultar_aviso' => 'javascripts#hide_announcements', :as => :hide_announcements

	match 'partidos/:id/poner_resultado' => 'games#set_score', :as => :set_score

	match 'encasillado/:id/fase_de_grupos' => 'standings#set_group_stage', :as => :set_group_stage

	match 'horario/:id/replica/:current_id' => 'timetables#set_copy_timetable', :as => :set_copy_timetable

	match 'festivo/:venue_id/abierto/:block_token' => 'holidays#set_holiday_open', :as => :set_holiday_open
	match 'festivo/:venue_id/cerrado/:block_token' => 'holidays#set_holiday_closed', :as => :set_holiday_closed
	match 'festivo/:venue_id/nada/:block_token'=> 'holidays#set_holiday_none', :as => :set_holiday_none

	match 'escuadras/:id/borrar_escuadra/:cup' => 'escuadras#borrar_escuadra', :as => :borrar_escuadra

	resources :authentications
	resources :user_sessions
	resources :users do
		collection do
      # post :rpx_create
			get :list
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
	resources :types
	resources :sports
	resources :roles


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

	resources :activations
	resources :messages do
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
			get :list_guess_user
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

	resources :timetables
	
	resources :users do
		resources :messages
	end

  # resources :prospects
  # resources :customers
  # resources :surveys
	resources :companies
	resources :branches
	

	match ':controller/:action.:format' => '#index'
	
  match 'user_sessions/*user_sessions' => redirect('/acceso_session')

end
#== Route Map
# Generated on 10 Nov 2013 19:38
#
#                                        /                                                              home#index
#                              qr        /qr(.:format)                                                  home#index
#                          widget        /widget(.:format)                                              widget#index
#                     widget_home        /widget/home(.:format)                                         widget#home
#              widget_login_popup        /widget/login/popup(.:format)                                  widget#login_check
#           widget_check_omniauth        /widget/check_omniauth(.:format)                               widget#check_omniauth
#                   widget_logout        /widget/logout(.:format)                                       user_sessions#destroy_widget
#                   widget_signup        /widget/signup(.:format)                                       widget#signup
#              widget_do_apuntate        /widget/do_apuntate(.:format)                                  widget#do_apuntate
#        widget_change_user_state        /widget/:matchid/change_user_state/:newstate(.:format)         widget#change_user_state
#                 widget_set_team        /widget/:matchid/change_team(.:format)                         widget#set_team
#            widget_event_details        /widget/event/:event_id(.:format)                              widget#event_details
#     widget_event_details_noshow        /widget/event/:event_id/noshow(.:format)                       widget#event_details_noshow
# widget_event_details_lastminute        /widget/event/:event_id/lastminute(.:format)                   widget#event_details_lastminute
#         widget_event_invitation        /widget/event/:event_id/invitation(.:format)                   widget#event_invitation
#              rpx_token_sessions        /rpx_token_sessions(.:format)                                  user_sessions#rpx_create
#                      rpx_signup        /rpx_signup(.:format)                                          users#rpx_new
#                      rpx_create        /rpx_create(.:format)                                          users#rpx_create
#                        provider        /omniauth_new(.:format)                                        users#omniauth_new
#                        callback        /auth/:provider/callback(.:format)                             authentications#create
#                         failure        /auth/failure(.:format)                                        authentications#failure
#                    post_failure        /failure(.:format)                                             authentications#failure
#                           blank        /auth/:provider(.:format)                                      authentications#blank
#                          signup        /registrate(.:format)                                          users#signup
#                           login        /acceso_session(.:format)                                      user_sessions#new
#                          logout        /cierra_session(.:format)                                      user_sessions#destroy
#              confirmation_token        /confirmacion/:token(.:format)                                 users#confirmation
#                        language        /configurar_idioma(.:format)                                   users#set_language
#                       team_list        /jugadores_de_equipo(.:format)                                 groups#team_list
#                     team_roster        /evento_deportivo_convocado(.:format)                          schedules#team_roster
#                team_last_minute        /evento_deportivo_ultima_hora(.:format)                        schedules#team_last_minute
#                    team_no_show        /evento_deportivo_ausente(.:format)                            schedules#team_no_show
#                   schedule_list        /eventos_equipo(.:format)                                      schedules#schedule_list
#                     marker_list        /lista_marcadores(.:format)                                    markers#marker_list
#                  challenge_list        /retos_copa(.:format)                                          challenges#challenge_list
#                       join_team        /mi_equipo/:id/unirse_equipo/:teammate(.:format)               teammates#join_team
#                      leave_team        /mi_equipo/:id/dejar_equipo/:teammate(.:format)                teammates#leave_team
#                join_team_accept        /mi_equipo/:id/acepta_unirse_equipo(.:format)                  teammates#join_team_accept
#               join_team_decline        /mi_equipo/:id/deniega_unirse_equipo(.:format)                 teammates#join_team_decline
#                       join_item        /mi_equipo/:id/unirse/:teammate(.:format)                      teammates#join_item
#                      leave_item        /mi_equipo/:id/dejar/:teammate(.:format)                       teammates#leave_item
#                join_item_accept        /mi_equipo/:id/acepta_unirse(.:format)                         teammates#join_item_accept
#               join_item_decline        /mi_equipo/:id/deniega_unirse(.:format)                        teammates#join_item_decline
#                     set_manager        /jugadores/:id/marcar_manager/:group(.:format)                 users#set_manager
#                  remove_manager        /jugadores/:id/borrar_manager/:group(.:format)                 users#remove_manager
#                 set_sub_manager        /jugadores/:id/marcar_sub_manager/:group(.:format)             users#set_sub_manager
#              remove_sub_manager        /jugadores/:id/borrar_sub_manager/:group(.:format)             users#remove_sub_manager
#                set_subscription        /jugadores/:id/marcar_subscripcion/:group(.:format)            users#set_subscription
#             remove_subscription        /jugadores/:id/borrar_subscripcion/:group(.:format)            users#remove_subscription
#                        petition        /jugadores/:id/peticiones_equipo(.:format)                     users#petition
#               set_private_phone        /jugadores/:id/ocultar_telefono(.:format)                      users#set_private_phone
#             set_private_profile        /jugadores/:id/ocultar_perfil(.:format)                        users#set_private_profile
#       set_teammate_notification        /jugadores/:id/habilitar_notificaciones(.:format)              users#set_teammate_notification
#        set_message_notification        /jugadores/:id/habilitar_mensajes(.:format)                    users#set_message_notification
#    set_last_minute_notification        /jugadores/:id/habilitar_ultima_hora(.:format)                 users#set_last_minute_notification
#                    set_whatsapp        /jugadores/:id/utilizo_whatsapp(.:format)                      users#set_whatsapp
#                      set_public        /eventos/:id/marcar_como_publico(.:format)                     schedules#set_public
#            set_previous_profile        /eventos/:id/habilitar_perfil_previo(.:format)                 schedules#set_previous_profile
#                    set_reminder        /eventos/:id/marcar_recordatorio(.:format)                     schedules#set_reminder
#                   group_current        /eventos/:id/actual_evento(.:format)                           schedules#group_current
#                  group_previous        /eventos/:id/previo_evento(.:format)                           schedules#group_previous
#          set_automatic_petition        /equipos/:id/unirse_automaticamente(.:format)                  groups#set_automatic_petition
#          set_group_subscription        /equipos/:id/marcar_subscripcion/:venue(.:format)              groups#set_subscription
#       remove_group_subscription        /equipos/:id/borrar_subscripcion/:venue(.:format)              groups#remove_subscription
#     set_auto_petition_challenge        /retos_copa/:id/unirse_auto_reto(.:format)                     challenges#set_auto_petition_challenge
#      set_challenge_subscription        /retos_copa/:id/marcar_reto_subscripcion/:challenge(.:format)  challenges#set_challenge_subscription
#   remove_challenge_subscription        /retos_copa/:id/borrar_reto_subscripcion/:challenge(.:format)  challenges#remove_challenge_subscription
#                      match_team        /jornadas/:id/cambio_equipo(.:format)                          matches#set_team
#                    match_status        /jornadas/:id/cambio_convocatoria/:type(.:format)              matches#set_status
#                     match_token        /jornadas/:id/cambio_convocatoria/:type/:block_token(.:format) matches#set_status_link
#                   reply_message        /mensajes/responder/:block_token(.:format)                     messages#reply
#                   trash_message        /mensajes/borrar/:block_token(.:format)                        messages#trash
#                        upcoming        /eventos_deportivos(.:format)                                  home#upcoming
#                          search        /buqueda(.:format)                                             home#search
#                   advertisement        /comunicado(.:format)                                          home#advertisement
#                          widget        /widget(.:format)                                              home#widget
#                          search        /buscar_en_mapa(.:format)                                      markers#search_map
#                         address        /address_map(.:format)                                         markers#address_map
#                           about        /sobre(.:format)                                               home#about
#                    terms_of_use        /terminos(.:format)                                            home#terms_of_use
#                  privacy_policy        /privacidad(.:format)                                          home#privacy_policy
#                             faq        /ayuda(.:format)                                               home#faq
#                         success        /success(.:format)                                             home#success
#                         persona        /persona(.:format)                                             home#persona
#                        feedback        /feedback(.:format)                                            home#feedback
#                    how_it_works        /how_it_works(.:format)                                        home#how_it_works
#                    for_websites        /for_websites(.:format)                                        home#for_websites
#                          launch        /launch(.:format)                                              home#launch
#                     personalize        /companies/:id/personalize(.:format)                           companies#personalize
#              hide_announcements        /ocultar_aviso(.:format)                                       javascripts#hide_announcements
#                       set_score        /partidos/:id/poner_resultado(.:format)                        games#set_score
#                 set_group_stage        /encasillado/:id/fase_de_grupos(.:format)                      standings#set_group_stage
#              set_copy_timetable        /horario/:id/replica/:current_id(.:format)                     timetables#set_copy_timetable
#                set_holiday_open        /festivo/:venue_id/abierto/:block_token(.:format)              holidays#set_holiday_open
#              set_holiday_closed        /festivo/:venue_id/cerrado/:block_token(.:format)              holidays#set_holiday_closed
#                set_holiday_none        /festivo/:venue_id/nada/:block_token(.:format)                 holidays#set_holiday_none
#                 borrar_escuadra        /escuadras/:id/borrar_escuadra/:cup(.:format)                  escuadras#borrar_escuadra
#                 authentications GET    /authentications(.:format)                                     authentications#index
#                                 POST   /authentications(.:format)                                     authentications#create
#              new_authentication GET    /authentications/new(.:format)                                 authentications#new
#             edit_authentication GET    /authentications/:id/edit(.:format)                            authentications#edit
#                  authentication GET    /authentications/:id(.:format)                                 authentications#show
#                                 PUT    /authentications/:id(.:format)                                 authentications#update
#                                 DELETE /authentications/:id(.:format)                                 authentications#destroy
#                   user_sessions GET    /user_sessions(.:format)                                       user_sessions#index
#                                 POST   /user_sessions(.:format)                                       user_sessions#create
#                new_user_session GET    /user_sessions/new(.:format)                                   user_sessions#new
#               edit_user_session GET    /user_sessions/:id/edit(.:format)                              user_sessions#edit
#                    user_session GET    /user_sessions/:id(.:format)                                   user_sessions#show
#                                 PUT    /user_sessions/:id(.:format)                                   user_sessions#update
#                                 DELETE /user_sessions/:id(.:format)                                   user_sessions#destroy
#                rpx_create_users POST   /users/rpx_create(.:format)                                    users#rpx_create
#                      list_users GET    /users/list(.:format)                                          users#list
#                    notice_users GET    /users/notice(.:format)                                        users#notice
#                           users GET    /users(.:format)                                               users#index
#                                 POST   /users(.:format)                                               users#create
#                        new_user GET    /users/new(.:format)                                           users#new
#                       edit_user GET    /users/:id/edit(.:format)                                      users#edit
#                            user GET    /users/:id(.:format)                                           users#show
#                                 PUT    /users/:id(.:format)                                           users#update
#                                 DELETE /users/:id(.:format)                                           users#destroy
#                  list_schedules GET    /schedules/list(.:format)                                      schedules#list
#          archive_list_schedules GET    /schedules/archive_list(.:format)                              schedules#archive_list
#               my_list_schedules GET    /schedules/my_list(.:format)                                   schedules#my_list
#                       schedules GET    /schedules(.:format)                                           schedules#index
#                                 POST   /schedules(.:format)                                           schedules#create
#                    new_schedule GET    /schedules/new(.:format)                                       schedules#new
#                   edit_schedule GET    /schedules/:id/edit(.:format)                                  schedules#edit
#                        schedule GET    /schedules/:id(.:format)                                       schedules#show
#                                 PUT    /schedules/:id(.:format)                                       schedules#update
#                                 DELETE /schedules/:id(.:format)                                       schedules#destroy
#                     list_groups GET    /groups/list(.:format)                                         groups#list
#                          groups GET    /groups(.:format)                                              groups#index
#                                 POST   /groups(.:format)                                              groups#create
#                       new_group GET    /groups/new(.:format)                                          groups#new
#                      edit_group GET    /groups/:id/edit(.:format)                                     groups#edit
#                           group GET    /groups/:id(.:format)                                          groups#show
#                                 PUT    /groups/:id(.:format)                                          groups#update
#                                 DELETE /groups/:id(.:format)                                          groups#destroy
#                         markers GET    /markers(.:format)                                             markers#index
#                                 POST   /markers(.:format)                                             markers#create
#                      new_marker GET    /markers/new(.:format)                                         markers#new
#                     edit_marker GET    /markers/:id/edit(.:format)                                    markers#edit
#                          marker GET    /markers/:id(.:format)                                         markers#show
#                                 PUT    /markers/:id(.:format)                                         markers#update
#                                 DELETE /markers/:id(.:format)                                         markers#destroy
#                 list_scorecards GET    /scorecards/list(.:format)                                     scorecards#list
#                      scorecards GET    /scorecards(.:format)                                          scorecards#index
#                                 POST   /scorecards(.:format)                                          scorecards#create
#                   new_scorecard GET    /scorecards/new(.:format)                                      scorecards#new
#                  edit_scorecard GET    /scorecards/:id/edit(.:format)                                 scorecards#edit
#                       scorecard GET    /scorecards/:id(.:format)                                      scorecards#show
#                                 PUT    /scorecards/:id(.:format)                                      scorecards#update
#                                 DELETE /scorecards/:id(.:format)                                      scorecards#destroy
#                         matches GET    /matches(.:format)                                             matches#index
#                                 POST   /matches(.:format)                                             matches#create
#                       new_match GET    /matches/new(.:format)                                         matches#new
#                      edit_match GET    /matches/:id/edit(.:format)                                    matches#edit
#                           match GET    /matches/:id(.:format)                                         matches#show
#                                 PUT    /matches/:id(.:format)                                         matches#update
#                                 DELETE /matches/:id(.:format)                                         matches#destroy
#                     invitations GET    /invitations(.:format)                                         invitations#index
#                                 POST   /invitations(.:format)                                         invitations#create
#                  new_invitation GET    /invitations/new(.:format)                                     invitations#new
#                 edit_invitation GET    /invitations/:id/edit(.:format)                                invitations#edit
#                      invitation GET    /invitations/:id(.:format)                                     invitations#show
#                                 PUT    /invitations/:id(.:format)                                     invitations#update
#                                 DELETE /invitations/:id(.:format)                                     invitations#destroy
#                       teammates GET    /teammates(.:format)                                           teammates#index
#                                 POST   /teammates(.:format)                                           teammates#create
#                    new_teammate GET    /teammates/new(.:format)                                       teammates#new
#                   edit_teammate GET    /teammates/:id/edit(.:format)                                  teammates#edit
#                        teammate GET    /teammates/:id(.:format)                                       teammates#show
#                                 PUT    /teammates/:id(.:format)                                       teammates#update
#                                 DELETE /teammates/:id(.:format)                                       teammates#destroy
#                           types GET    /types(.:format)                                               types#index
#                                 POST   /types(.:format)                                               types#create
#                        new_type GET    /types/new(.:format)                                           types#new
#                       edit_type GET    /types/:id/edit(.:format)                                      types#edit
#                            type GET    /types/:id(.:format)                                           types#show
#                                 PUT    /types/:id(.:format)                                           types#update
#                                 DELETE /types/:id(.:format)                                           types#destroy
#                          sports GET    /sports(.:format)                                              sports#index
#                                 POST   /sports(.:format)                                              sports#create
#                       new_sport GET    /sports/new(.:format)                                          sports#new
#                      edit_sport GET    /sports/:id/edit(.:format)                                     sports#edit
#                           sport GET    /sports/:id(.:format)                                          sports#show
#                                 PUT    /sports/:id(.:format)                                          sports#update
#                                 DELETE /sports/:id(.:format)                                          sports#destroy
#                           roles GET    /roles(.:format)                                               roles#index
#                                 POST   /roles(.:format)                                               roles#create
#                        new_role GET    /roles/new(.:format)                                           roles#new
#                       edit_role GET    /roles/:id/edit(.:format)                                      roles#edit
#                            role GET    /roles/:id(.:format)                                           roles#show
#                                 PUT    /roles/:id(.:format)                                           roles#update
#                                 DELETE /roles/:id(.:format)                                           roles#destroy
#                   list_payments GET    /payments/list(.:format)                                       payments#list
#                        payments GET    /payments(.:format)                                            payments#index
#                                 POST   /payments(.:format)                                            payments#create
#                     new_payment GET    /payments/new(.:format)                                        payments#new
#                    edit_payment GET    /payments/:id/edit(.:format)                                   payments#edit
#                         payment GET    /payments/:id(.:format)                                        payments#show
#                                 PUT    /payments/:id(.:format)                                        payments#update
#                                 DELETE /payments/:id(.:format)                                        payments#destroy
#                       list_fees GET    /fees/list(.:format)                                           fees#list
#                       item_fees GET    /fees/item(.:format)                                           fees#item
#                        due_fees GET    /fees/due(.:format)                                            fees#due
#                            fees GET    /fees(.:format)                                                fees#index
#                                 POST   /fees(.:format)                                                fees#create
#                         new_fee GET    /fees/new(.:format)                                            fees#new
#                        edit_fee GET    /fees/:id/edit(.:format)                                       fees#edit
#                             fee GET    /fees/:id(.:format)                                            fees#show
#                                 PUT    /fees/:id(.:format)                                            fees#update
#                                 DELETE /fees/:id(.:format)                                            fees#destroy
#                     activations GET    /activations(.:format)                                         activations#index
#                                 POST   /activations(.:format)                                         activations#create
#                  new_activation GET    /activations/new(.:format)                                     activations#new
#                 edit_activation GET    /activations/:id/edit(.:format)                                activations#edit
#                      activation GET    /activations/:id(.:format)                                     activations#show
#                                 PUT    /activations/:id(.:format)                                     activations#update
#                                 DELETE /activations/:id(.:format)                                     activations#destroy
#                   sent_messages GET    /messages/sent(.:format)                                       messages#sent
#                  trash_messages GET    /messages/trash(.:format)                                      messages#trash
#                        messages GET    /messages(.:format)                                            messages#index
#                                 POST   /messages(.:format)                                            messages#create
#                     new_message GET    /messages/new(.:format)                                        messages#new
#                    edit_message GET    /messages/:id/edit(.:format)                                   messages#edit
#                         message GET    /messages/:id(.:format)                                        messages#show
#                                 PUT    /messages/:id(.:format)                                        messages#update
#                                 DELETE /messages/:id(.:format)                                        messages#destroy
#                  list_standings GET    /standings/list(.:format)                                      standings#list
#             show_list_standings GET    /standings/show_list(.:format)                                 standings#show_list
#              show_all_standings GET    /standings/show_all(.:format)                                  standings#show_all
#                       standings GET    /standings(.:format)                                           standings#index
#                                 POST   /standings(.:format)                                           standings#create
#                    new_standing GET    /standings/new(.:format)                                       standings#new
#                   edit_standing GET    /standings/:id/edit(.:format)                                  standings#edit
#                        standing GET    /standings/:id(.:format)                                       standings#show
#                                 PUT    /standings/:id(.:format)                                       standings#update
#                                 DELETE /standings/:id(.:format)                                       standings#destroy
#                     connections GET    /connections(.:format)                                         connections#index
#                                 POST   /connections(.:format)                                         connections#create
#                  new_connection GET    /connections/new(.:format)                                     connections#new
#                 edit_connection GET    /connections/:id/edit(.:format)                                connections#edit
#                      connection GET    /connections/:id(.:format)                                     connections#show
#                                 PUT    /connections/:id(.:format)                                     connections#update
#                                 DELETE /connections/:id(.:format)                                     connections#destroy
#              list_announcements GET    /announcements/list(.:format)                                  announcements#list
#                   announcements GET    /announcements(.:format)                                       announcements#index
#                                 POST   /announcements(.:format)                                       announcements#create
#                new_announcement GET    /announcements/new(.:format)                                   announcements#new
#               edit_announcement GET    /announcements/:id/edit(.:format)                              announcements#edit
#                    announcement GET    /announcements/:id(.:format)                                   announcements#show
#                                 PUT    /announcements/:id(.:format)                                   announcements#update
#                                 DELETE /announcements/:id(.:format)                                   announcements#destroy
#                       list_cups GET    /cups/list(.:format)                                           cups#list
#                            cups GET    /cups(.:format)                                                cups#index
#                                 POST   /cups(.:format)                                                cups#create
#                         new_cup GET    /cups/new(.:format)                                            cups#new
#                        edit_cup GET    /cups/:id/edit(.:format)                                       cups#edit
#                             cup GET    /cups/:id(.:format)                                            cups#show
#                                 PUT    /cups/:id(.:format)                                            cups#update
#                                 DELETE /cups/:id(.:format)                                            cups#destroy
#                      list_games GET    /games/list(.:format)                                          games#list
#                           games GET    /games(.:format)                                               games#index
#                                 POST   /games(.:format)                                               games#create
#                        new_game GET    /games/new(.:format)                                           games#new
#                       edit_game GET    /games/:id/edit(.:format)                                      games#edit
#                            game GET    /games/:id(.:format)                                           games#show
#                                 PUT    /games/:id(.:format)                                           games#update
#                                 DELETE /games/:id(.:format)                                           games#destroy
#                 list_challenges GET    /challenges/list(.:format)                                     challenges#list
#                      challenges GET    /challenges(.:format)                                          challenges#index
#                                 POST   /challenges(.:format)                                          challenges#create
#                   new_challenge GET    /challenges/new(.:format)                                      challenges#new
#                  edit_challenge GET    /challenges/:id/edit(.:format)                                 challenges#edit
#                       challenge GET    /challenges/:id(.:format)                                      challenges#show
#                                 PUT    /challenges/:id(.:format)                                      challenges#update
#                                 DELETE /challenges/:id(.:format)                                      challenges#destroy
#                      list_casts GET    /casts/list(.:format)                                          casts#list
#                list_guess_casts GET    /casts/list_guess(.:format)                                    casts#list_guess
#           list_guess_user_casts GET    /casts/list_guess_user(.:format)                               casts#list_guess_user
#                           casts GET    /casts(.:format)                                               casts#index
#                                 POST   /casts(.:format)                                               casts#create
#                        new_cast GET    /casts/new(.:format)                                           casts#new
#                       edit_cast GET    /casts/:id/edit(.:format)                                      casts#edit
#                            cast GET    /casts/:id(.:format)                                           casts#show
#                                 PUT    /casts/:id(.:format)                                           casts#update
#                                 DELETE /casts/:id(.:format)                                           casts#destroy
#                       escuadras GET    /escuadras(.:format)                                           escuadras#index
#                                 POST   /escuadras(.:format)                                           escuadras#create
#                    new_escuadra GET    /escuadras/new(.:format)                                       escuadras#new
#                   edit_escuadra GET    /escuadras/:id/edit(.:format)                                  escuadras#edit
#                        escuadra GET    /escuadras/:id(.:format)                                       escuadras#show
#                                 PUT    /escuadras/:id(.:format)                                       escuadras#update
#                                 DELETE /escuadras/:id(.:format)                                       escuadras#destroy
#                     list_venues GET    /venues/list(.:format)                                         venues#list
#                          venues GET    /venues(.:format)                                              venues#index
#                                 POST   /venues(.:format)                                              venues#create
#                       new_venue GET    /venues/new(.:format)                                          venues#new
#                      edit_venue GET    /venues/:id/edit(.:format)                                     venues#edit
#                           venue GET    /venues/:id(.:format)                                          venues#show
#                                 PUT    /venues/:id(.:format)                                          venues#update
#                                 DELETE /venues/:id(.:format)                                          venues#destroy
#              list_installations GET    /installations/list(.:format)                                  installations#list
#                   installations GET    /installations(.:format)                                       installations#index
#                                 POST   /installations(.:format)                                       installations#create
#                new_installation GET    /installations/new(.:format)                                   installations#new
#               edit_installation GET    /installations/:id/edit(.:format)                              installations#edit
#                    installation GET    /installations/:id(.:format)                                   installations#show
#                                 PUT    /installations/:id(.:format)                                   installations#update
#                                 DELETE /installations/:id(.:format)                                   installations#destroy
#               list_reservations GET    /reservations/list(.:format)                                   reservations#list
#                    reservations GET    /reservations(.:format)                                        reservations#index
#                                 POST   /reservations(.:format)                                        reservations#create
#                 new_reservation GET    /reservations/new(.:format)                                    reservations#new
#                edit_reservation GET    /reservations/:id/edit(.:format)                               reservations#edit
#                     reservation GET    /reservations/:id(.:format)                                    reservations#show
#                                 PUT    /reservations/:id(.:format)                                    reservations#update
#                                 DELETE /reservations/:id(.:format)                                    reservations#destroy
#                      timetables GET    /timetables(.:format)                                          timetables#index
#                                 POST   /timetables(.:format)                                          timetables#create
#                   new_timetable GET    /timetables/new(.:format)                                      timetables#new
#                  edit_timetable GET    /timetables/:id/edit(.:format)                                 timetables#edit
#                       timetable GET    /timetables/:id(.:format)                                      timetables#show
#                                 PUT    /timetables/:id(.:format)                                      timetables#update
#                                 DELETE /timetables/:id(.:format)                                      timetables#destroy
#                   user_messages GET    /users/:user_id/messages(.:format)                             messages#index
#                                 POST   /users/:user_id/messages(.:format)                             messages#create
#                new_user_message GET    /users/:user_id/messages/new(.:format)                         messages#new
#               edit_user_message GET    /users/:user_id/messages/:id/edit(.:format)                    messages#edit
#                    user_message GET    /users/:user_id/messages/:id(.:format)                         messages#show
#                                 PUT    /users/:user_id/messages/:id(.:format)                         messages#update
#                                 DELETE /users/:user_id/messages/:id(.:format)                         messages#destroy
#                                 GET    /users(.:format)                                               users#index
#                                 POST   /users(.:format)                                               users#create
#                                 GET    /users/new(.:format)                                           users#new
#                                 GET    /users/:id/edit(.:format)                                      users#edit
#                                 GET    /users/:id(.:format)                                           users#show
#                                 PUT    /users/:id(.:format)                                           users#update
#                                 DELETE /users/:id(.:format)                                           users#destroy
#                       prospects GET    /prospects(.:format)                                           prospects#index
#                                 POST   /prospects(.:format)                                           prospects#create
#                    new_prospect GET    /prospects/new(.:format)                                       prospects#new
#                   edit_prospect GET    /prospects/:id/edit(.:format)                                  prospects#edit
#                        prospect GET    /prospects/:id(.:format)                                       prospects#show
#                                 PUT    /prospects/:id(.:format)                                       prospects#update
#                                 DELETE /prospects/:id(.:format)                                       prospects#destroy
#                       customers GET    /customers(.:format)                                           customers#index
#                                 POST   /customers(.:format)                                           customers#create
#                    new_customer GET    /customers/new(.:format)                                       customers#new
#                   edit_customer GET    /customers/:id/edit(.:format)                                  customers#edit
#                        customer GET    /customers/:id(.:format)                                       customers#show
#                                 PUT    /customers/:id(.:format)                                       customers#update
#                                 DELETE /customers/:id(.:format)                                       customers#destroy
#                         surveys GET    /surveys(.:format)                                             surveys#index
#                                 POST   /surveys(.:format)                                             surveys#create
#                      new_survey GET    /surveys/new(.:format)                                         surveys#new
#                     edit_survey GET    /surveys/:id/edit(.:format)                                    surveys#edit
#                          survey GET    /surveys/:id(.:format)                                         surveys#show
#                                 PUT    /surveys/:id(.:format)                                         surveys#update
#                                 DELETE /surveys/:id(.:format)                                         surveys#destroy
#                       companies GET    /companies(.:format)                                           companies#index
#                                 POST   /companies(.:format)                                           companies#create
#                     new_company GET    /companies/new(.:format)                                       companies#new
#                    edit_company GET    /companies/:id/edit(.:format)                                  companies#edit
#                         company GET    /companies/:id(.:format)                                       companies#show
#                                 PUT    /companies/:id(.:format)                                       companies#update
#                                 DELETE /companies/:id(.:format)                                       companies#destroy
#                        branches GET    /branches(.:format)                                            branches#index
#                                 POST   /branches(.:format)                                            branches#create
#                      new_branch GET    /branches/new(.:format)                                        branches#new
#                     edit_branch GET    /branches/:id/edit(.:format)                                   branches#edit
#                          branch GET    /branches/:id(.:format)                                        branches#show
#                                 PUT    /branches/:id(.:format)                                        branches#update
#                                 DELETE /branches/:id(.:format)                                        branches#destroy
#                                        /:controller/:action.:format                                   :controller#index
#                                        /user_sessions/*user_sessions(.:format)                        :controller#:action
