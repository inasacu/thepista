class CastsController < ApplicationController
  before_filter :require_user
  before_filter :has_member_access, :only => [:index, :list, :edit]

  def index
    @user = User.find(params[:user_id])    
    @casts = Cast.current_challenge(@user, @challenge, params[:page])
    @cup = @challenge.cup
	render @the_template
  end
  
  def list
    @casts = Cast.current_challenge(@challenge.users, @challenge, params[:page])
    @cup = @challenge.cup    
    set_the_template('casts/index')
	render @the_template
  end
  
  def list_guess_user
    @challenge = Challenge.find(params[:id])
    @cup = @challenge.cup
    @users = []
    @challenge.users.each {|user| @users << user}
    @casts = Cast.guess_casts(@users, @challenge, params[:page])      
    set_the_template('casts/index')
	  render @the_template
  end
  
  def list_guess
    @cup = Cup.find(params[:id])
    @challenges = @cup.challenges
    @users = []
    @challenges.each {|challenge| challenge.users.each {|user| @users << user}}
    @casts = Cast.guess_casts(@users, @challenges, params[:page])      
    set_the_template('casts/index')
		render @the_template
  end

	def edit
		counter = 0
		@casts = Cast.current_casts(current_user, @challenge)
		@cast = @casts.first  
		@casts.each {|cast| counter += 1  if (current_user == cast.user and cast.cast_before_game)	}

		unless counter > 0
			redirect_back_or_default('/index') 
			return 
		end 
		render @the_template
	end

  def update
    @cast = Cast.find(params[:id])
    
    unless is_current_member_of(@cast.challenge) and current_user == @cast.user
      warning_unauthorized
      redirect_back_or_default('/index')
      return
    end
    
		if params[:cast][:cast_attributes]
      Cast.save_casts(@cast, params[:cast][:cast_attributes])
      Cast.calculate_standing(@cast)

      controller_successful_update
      redirect_to casts_path(:id => @cast.challenge, :user_id => current_user)
      return
    else
      render :action => 'edit'
    end
  end
  
  private
  
  def has_member_access
    @challenge = Challenge.find(params[:id])
    unless is_current_member_of(@challenge)
      warning_unauthorized
      redirect_to root_url
      return
    end
  end
  
end
