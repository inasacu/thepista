class GamesController < ApplicationController
	before_filter :require_user

	before_filter :get_game, :only => [:show, :edit, :update, :destroy, :set_score, :set_the_game_jornada]
	before_filter :get_cup, :only =>[:new, :index, :list]
	before_filter :has_manager_access, :only => [:edit, :update, :destroy]

	def index
		@games = Game.group_stage_games(@cup, params[:page])
		render @the_template
	end

	def list
		@games = Game.group_round_games(@cup, params[:page])
		set_the_template('games/index')
		render @the_template  
	end

	def show
		if @game.type_name == 'GroupStage'
			redirect_to :action => 'index', :id => @cup
			return
		else
			redirect_to :action => 'list', :id => @cup
			return
		end    
		render @the_template     
	end

	def new
		@game = Game.new

		unless current_user.is_manager_of?(@cup)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end

		if @cup
			# @home = @cup.the_escuadras
			# @away = @cup.the_escuadras

			the_last_game = @cup.games.last

			@game.cup_id = @cup.id      
			@game.starts_at = @cup.starts_at
			@game.ends_at = @cup.starts_at + (60 * 60 * 2)
			@game.reminder_at = @cup.starts_at - 2.day
			@game.type_name = 'GroupStage'
			@game.jornada = 1

			# default point values
			@game.points_for_single = POINTS_FOR_SINGLE
			@game.points_for_double = POINTS_FOR_DOUBLE
			@game.points_for_winner = POINTS_FOR_WINNER
			@game.points_for_draw = POINTS_FOR_DRAW
			@game.points_for_goal_difference = POINTS_FOR_GOAL_DIFFERENCE
			@game.points_for_goal_total = POINTS_FOR_GOAL_TOTAL
		end

		# @previous_game = Game.find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?) ", @cup.id])    
		@previous_game = @cup.games.last

		unless @previous_game.nil?
			@game.cup_id = @cup.id  
			@game.name = @previous_game.name      

			@game.starts_at = @previous_game.starts_at + 1.days
			@game.ends_at = @previous_game.ends_at + 1.days
			@game.reminder_at = @previous_game.starts_at - 1.day        

			@game.type_name = @previous_game.type_name      

			@game.points_for_single = @previous_game.points_for_single      
			@game.points_for_double = @previous_game.points_for_double      
			@game.points_for_draw = @previous_game.points_for_draw    
			@game.points_for_goal_difference = @previous_game.points_for_goal_difference    
			@game.points_for_goal_total = @previous_game.points_for_goal_total    
			@game.points_for_winner = @previous_game.points_for_winner         

			@game.jornada = @previous_game.jornada.to_i + 1
			@game.home_ranking = @previous_game.home_ranking
			@game.away_ranking = @previous_game.away_ranking
		end
	end

	def create
		@game = Game.new(params[:game])  
		@game.ends_at_date = @game.starts_at_date
		@game.type_name = 'GroupStage' unless @game.cup.official
		
		unless is_current_manager_of(@game.cup)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end

		if @game.save 			
			successful_create
			redirect_to @game
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('games/new')
		render @the_template
	end

	def update
		if @game.update_attributes(params[:game]) 
			# Standing.create_cup_escuadra_standing(@game.cup)
			controller_successful_update

			unless @game.all_group_stage_played(@game.cup)
				redirect_to games_path(:id => @game.cup)
			else
				redirect_to list_games_path(:id => @game.cup)
			end
			return
		else
			render :action => 'edit'
		end
	end

	def set_the_game_jornada

		unless current_user.is_manager_of?(@cup)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end

		jornada = params[:the_game][:jornada]
		if @game.update_attributes('jornada' => jornada)
			controller_successful_update
		end
		redirect_to games_path(:id => @cup)
		return
	end

	def set_score
		render @the_template
	end

	private
	def has_manager_access
		unless is_current_manager_of(@cup)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end

	def get_game
		@game = Game.find(params[:id])
		@cup = @game.cup 
	end

	def get_cup
		@cup = Cup.find(params[:id])      
		unless @cup
			redirect_to(cups_url)
			return
		end
	end
end

