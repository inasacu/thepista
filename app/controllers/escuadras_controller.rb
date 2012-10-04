class EscuadrasController < ApplicationController
	before_filter :require_user
  # before_filter :the_maximo, :only => [:new, :create, :edit, :update,  :destroy, :remove_escuadra]

	def index
		store_location
		@cup = Cup.find(params[:id])
		@escuadras = Escuadra.cup_escuadras(@cup, params[:page]) 
	end

	def show
		@escuadra = Escuadra.find(params[:id])
		@cup = @escuadra.cups.first
		redirect_to escuadras_path(:id => @cup)    
		return
	end

	def new
		@escuadra = Escuadra.new
		@cup = Cup.find(params[:id])  
	end

	def create
		@cup = Cup.find(params[:cup][:id])

		# escuadras for cup    
		if params[:escuadra_ids]
			@escuadras = Escuadra.find(params[:escuadra_ids])
			@escuadras.each do |escuadra| 
				escuadra.join_escuadra(@cup)
			end
			successful_create
			redirect_to escuadras_path(:id => @cup) and return
		end

		@escuadra = Escuadra.new(params[:escuadra])
		@escuadra.description = @escuadra.name

		if @escuadra.save and @escuadra.join_escuadra(@cup)

			if @cup.official
				@escuadra.item = @escuadra
				@escuadra.save
			end

			if @escuadra.item.nil?
				@escuadra.item = @escuadra
				@escuadra.save
			end

			successful_create
			redirect_to escuadras_path(:id => @cup) and return
		else
			render :action => 'new'
		end
	end

	def edit
		@escuadra = Escuadra.find(params[:id])
		@cup = @escuadra.cups.first 
		set_the_template('escuadras/new')
		render @the_template
	end

	def update
		@escuadra = Escuadra.find(params[:id])
		if @escuadra.update_attributes(params[:escuadra])
			controller_successful_update
			redirect_to @escuadra
		else
			render :action => 'edit'
		end
	end

	
	def borrar_escuadra
		@escuadra = Escuadra.find(params[:id])
		@cup = Cup.find(params[:cup])	
		CupsEscuadras.leave_escuadra(@escuadra, @cup)
		
		controller_successful_update
		redirect_back_or_default('/index')
	end

	private 
	def the_maximo
		unless the_maximo 
			redirect_to root_url
			return
		end
	end

end
