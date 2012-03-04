Thepista::Application.routes.draw do
  root :to => "home#index"  

  match '/' => 'home#index'
  
  match 'signup' => 'users#signup'#, :as => :signup
  match 'qr' => 'home#qr', :as => :qr
  
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
  match 'jugadores/third_party' => 'users#third_party', :as => :third_party
  match 'jugadores/associate_return' => 'users#associate_return', :as => :associate_return
  
  match 'eventos/:id/marcar_como_publico' => 'schedules#set_public', :as => :set_public
  match 'eventos/:id/habilitar_perfil_previo' => 'schedules#set_previous_profile', :as => :set_previous_profile
  match 'eventos/:id/marcar_recordatorio' => 'schedules#set_reminder', :as => :set_reminder
  match 'eventos/:id/actual_evento' => 'schedules#group_current_list', :as => :group_current
  match 'eventos/:id/previo_evento' => 'schedules#group_previous_list', :as => :group_previous
  
  match 'equipos/:id/habilitar_comentarios_equipo' => 'groups#set_enable_comments', :as => :set_group_enable_comments
  match 'equipos/:id/equipo_disponible' => 'groups#set_available', :as => :set_group_available
  match 'equipos/:id/buscar_jugado' => 'groups#set_looking', :as => :set_group_looking
  match 'equipos/:id/unirse_automaticamente' => 'groups#set_automatic_petition', :as => :set_group_auto
  
  match 'retos_copa/:id/unirse_automaticamente' => 'challenges#set_automatic_petition', :as => :set_challenge_auto
  
  match 'jornadas/:id/cambio_equipo' => 'matches#set_team', :as => :match_team
  match 'jornadas/:id/cambio_convocatoria/:type' => 'matches#set_status', :as => :match_status
  match 'jornadas/:id/cambio_convocatoria/:type/:block_token' => 'matches#set_status_link', :as => :match_token
  
  match 'mensajes/:id/responder' => 'messages#reply', :as => :reply_message
  match 'mensajes/:id/recuperar' => 'messages#undestroy', :as => :untrash_message
  
  match 'proximos_partidos' => 'home#upcoming', :as => :upcoming
  
  match 'busqueda' => 'home#search', :as => :search
  
  match 'comunicado' => 'home#advertisement', :as => :advertisement
  
  match 'buscar_en_mapa' => 'markers#search', :as => :search_map
  
  match 'address_map' => 'markers#address', :as => :address_map
  
  match 'clasificacion/:id/archivar' => 'scorecards#archive', :as => :archive_scorecard
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
  match 'festivo/:venue_id/nada/:block_token' => 'holidays#set_holiday_none', :as => :set_holiday_none

  # resources :user_sessions
  
	resources :users do
		collection do
			get :list
			get :recent_activity
			get :notice
			# get :signup
		end

		resources :messages

		member do
			post :rate
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

  resources :markers do
    collection do
      get :list
      get :direction
      get :full_list
    end
  end

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

  resources :auth
  resources :timetables
  resources :holidays

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
end