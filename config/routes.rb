Thepista::Application.routes.draw do

	root :to => "home#index" 	
	match '/' => 'home#index'
	match 'qr' => 'home#index'

	match 'rpx_token_sessions' => 'user_sessions#rpx_create', :as => :rpx_token_sessions
	match 'rpx_signup' => 'users#rpx_new', :as => :rpx_signup
	match 'rpx_create' => 'users#rpx_create', :as => :rpx_create

	match 'omniauth_new' => 'users#omniauth_new', :as => :provider 

	match '/auth/:provider/callback' => 'authentications#create', :as => :callback
	match '/auth/failure' => 'authentications#failure', :as => :failure
	match '/failure' => 'authentications#failure', :as => :post_failure
	match '/auth/:provider' => 'authentications#blank', :as => :blank


	match 'registrate' => 'users#signup', :as => :signup
	match 'acceso_session' => 'user_sessions#new', :as => :login
	match 'cierra_session' => 'user_sessions#destroy', :as => :logout

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
	match 'launch' => 'home#launch', :as => :launch

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
			post :rpx_create
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

	resources :password_resets
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

	resources :enchufados do
		collection do
			get :list
		end
	end
	
	resources :subplugs

	resources :timetables
	
	resources :users do
		resources :messages
	end

	resources :prospects
	resources :customers
	resources :surveys
	resources :companies
	resources :branches
	

	match ':controller/:action.:format' => '#index'

end
