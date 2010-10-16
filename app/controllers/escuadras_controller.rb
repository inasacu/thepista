class EscuadrasController < ApplicationController
  before_filter :require_user
    
  def index
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
    # @cup_escuadras = @cup.escuadras
    # @escuadras = Escuadra.find(:all, :conditions => ["item_type = 'Escuadra' and id not in (select escuadra_id from cups_escuadras where cup_id = ?)", @cup], :order => 'name')
    # @escuadras = Escuadra.find(:all, :conditions => ["item_type = 'Escuadra'"], :order => 'name')
  end

  def create
    @cup = Cup.find(params[:cup][:id])
    
    # escuadras for cup    
    if params[:escuadra_ids]
      @escuadras = Escuadra.find(params[:escuadra_ids])
      @escuadras.each do |escuadra| 
        escuadra.join_escuadra(@cup)
      end
      flash[:notice] = I18n.t(:successful_create)
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
      
      flash[:notice] = I18n.t(:successful_create)
      redirect_to escuadras_path(:id => @cup) and return
    else
      render :action => 'new'
    end
  end
  
  def edit
    @escuadra = Escuadra.find(params[:id])
    @cup = @escuadra.cups.first
  end

  def update
    @escuadra = Escuadra.find(params[:id])
    if @escuadra.update_attributes(params[:escuadra])
      flash[:success] = I18n.t(:successful_update)
      redirect_to @escuadra
    else
      render :action => 'edit'
    end
  end

  private 
  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end

end
