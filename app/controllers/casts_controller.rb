class CastsController < ApplicationController
  before_filter :require_user

  def index
    @challenge = Challenge.find(params[:id])
    # @casts = @challenge.casts.paginate :page => params[:page]#, :order => 'starts_at'
    @casts = Cast.current_challenge(current_user, @challenge, params[:page])
    @cup = @challenge.cup
  end

  def set_the_cast_home_score
    @cast = Cast.find(params[:id])

    unless current_user == @cast.user
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    home_score = params[:the_cast][:home_score]
    if @cast.update_attributes('home_score' => home_score)
      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_to casts_path(:id => @cast.challenge)
    return
  end

  def set_the_cast_away_score
    @cast = Cast.find(params[:id])

    unless current_user == @cast.user
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    away_score = params[:the_cast][:away_score]
    if @cast.update_attributes('away_score' => away_score)
      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_to casts_path(:id => @cast.challenge)
    return
  end

  def edit
    @challenge = Challenge.find(params[:id])

    unless current_user.is_manager_of?(@challenge)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end    
    
    @casts = Cast.current_casts(current_user, @challenge)
    @cast = @casts.first    
  end

  def update
    @cast = Cast.find(params[:id])
    
    # unless current_user.is_manager_of?(@challenge)
    #   flash[:warning] = I18n.t(:unauthorized)
    #   redirect_back_or_default('/index')
    #   return
    # end
    
    if @cast.update_attributes(params[:cast])
      Match.save_castes(@cast, params[:cast][:cast_attributes]) if params[:cast][:cast_attributes]
      Match.update_cast_details(@cast, current_user)

      flash[:notice] = I18n.t(:successful_update)
      redirect_to casts_path(:id => @cast.challenge)
      return
    else
      render :action => 'edit'
    end
  end
end
