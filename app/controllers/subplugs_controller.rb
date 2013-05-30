class SubplugsController < ApplicationController
  before_filter :require_user

  before_filter   :get_enchufado,           :only => [:new, :index, :show]
  before_filter   :get_subplug,    					:only => [:show, :edit, :update]
  before_filter   :has_manager_access,  		:only => [:edit, :update]

  def index  
    store_location
    @subplugs = Subplug.current_subplugs(@enchufado, params[:page])
    render @the_template   
  end

  def show
    store_location    
    render @the_template   
  end

	def new
		@subplug = Subplug.new

		if @enchufado
			@subplug.enchufado_id = @enchufado.id
			@subplug.play_id = @enchufado.play_id
			@subplug.service_id = @enchufado.service_id
		else 
			redirect_to root_url
		end

	end

  def create
    @subplug = Subplug.new(params[:subplug]) 
		@enchufado = Enchufado.find(@subplug.enchufado_id)

    if @subplug.save 
      successful_create
      redirect_to enchufados_url
    else
      render :action => 'new'
    end
  end

  def edit
    set_the_template('subplugs/new')
    render @the_template
  end

  def update
    if @subplug.update_attributes(params[:subplug])  
      controller_successful_update
      redirect_to @enchufado
    else
      render :action => 'edit'
    end
  end

  private
  def has_manager_access
    unless is_current_manager_of(@enchufado)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_subplug
    @subplug = Subplug.find(params[:id])
    @enchufado = @subplug.enchufado
  end

  def get_enchufado
    @enchufado = Enchufado.find(params[:enchufado_id])
  end

end
