class EnchufadosController < ApplicationController
	before_filter :require_user
	
	before_filter :get_enchufado, :only => [:show, :edit, :update]

	def index
		@enchufados = Enchufado.get_site_enchufados(params[:page]) 
	end
	
	def show
		@enchufados = Enchufado.where(["id = ?", @enchufado])
	end

	def new
		@enchufado = Enchufado.new
	end


	def create
		@enchufado = Enchufado.new(params[:enchufado])	
		@user = current_user

		if @enchufado.save and @enchufado.create_enchufado_details(current_user)
			successful_create
			
			@subplug = Subplug.new(:name => @enchufado.name, :enchufado_id => @enchufado.id, :url => @enchufado.url)
			@subplug.save
			
			redirect_to :enchufados
			
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('enchufados/new')
	end

	def update
		@original_enchufado = Enchufado.find(params[:id])

		if @enchufado.update_attributes(params[:enchufado]) 
			controller_successful_update
			redirect_to @enchufado
		else
			render :action => 'edit'
		end
	end

	private
	def get_enchufado
		@enchufado = Enchufado.find(params[:id])
	end

end

