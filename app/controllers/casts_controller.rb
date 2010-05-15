class CastsController < ApplicationController
  before_filter :require_user
  before_filter :has_member_access, :only => [:index, :edit]

  def index
    @user = User.find(params[:user_id])
    @casts = Cast.current_challenge(@user, @challenge, params[:page])
    @cup = @challenge.cup
  end

  def edit
    counter = 0
    @casts = Cast.current_casts(current_user, @challenge)
    @cast = @casts.first  
    @casts.each {|cast| counter += 1}

    unless counter > 0
      redirect_back_or_default('/index') 
      return 
    end
  end

  def update
    @cast = Cast.find(params[:id])
    
    unless current_user.is_member_of?(@cast.challenge) and current_user == @cast.user
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    if @cast.update_attributes(params[:cast])
      Cast.save_casts(@cast, params[:cast][:cast_attributes]) if params[:cast][:cast_attributes]
      Cast.calculate_standing(@cast)

      flash[:notice] = I18n.t(:successful_update)
      redirect_to casts_path(:id => @cast.challenge, :user_id => current_user)
      return
    else
      render :action => 'edit'
    end
  end
  
  private
  
  def has_member_access
    @challenge = Challenge.find(params[:id])
    unless current_user.is_member_of?(@challenge)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end
  
end
