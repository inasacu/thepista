class EscuadrasController < ApplicationController
  before_filter :require_user
  # before_filter :the_maximo

  def index    
    @cup = Cup.find(params[:id])
    @escuadras = @cup.escuadras
  end

  def list    
    @cup = Cup.find(params[:id])
    @escuadras = @cup.escuadras
    render :template => '/escuadras/index'
  end
  
  def show
    @escuadra = Escuadra.find(params[:id])
    @cup = @escuadra.cups.first
  end

  def new
    @escuadra = Escuadra.new
    @cup = Cup.find(params[:id])    
  end

  def create
    @escuadra = Escuadra.new(params[:escuadra])
    @escuadra.description = @escuadra.name
    @cup = Cup.find(params[:cup][:id])
     
    if @escuadra.save and @escuadra.join_escuadra(@cup)
      flash[:notice] = I18n.t(:successful_create)
      # redirect_to cups_url(:id => @cup) and return
      redirect_to cup_path(@cup) and return
    else
      render :action => 'new'
    end
  end

  def edit
    @escuadra = Escuadra.find(params[:id])
  end

  def update
    @escuadra = Escuadra.find(params[:id])
    if @escuadra.update_attributes(params[:escuadra])
      flash[:notice] = I18n.t(:successful_update)
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
