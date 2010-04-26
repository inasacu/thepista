class CastsController < ApplicationController
  before_filter :require_user

  def index
    @challenge = Challenge.find(params[:id])
    @casts = @challenge.casts.paginate :page => params[:page]#, :order => 'starts_at'
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
    redirect_to casts_path(:id => @cup)
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
    redirect_to casts_path(:id => @cup)
    return
  end
end
