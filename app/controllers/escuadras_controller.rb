class EscuadrasController < ApplicationController
	before_filter :require_user

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

    @has_escuadra_for_signup = true
    @the_escuadras = []
    @initial_escuadras = []

    the_groups = []

    if @cup.official
      @escuadras = Escuadra.find(:all, :conditions => ["official = ? and item_type = 'Escuadra' and id not in (select escuadra_id from cups_escuadras where cup_id = ?)", @cup.official, @cup])
      @escuadras.each {|escuadra| @the_escuadras << escuadra}
    else	

      @has_escuadra_for_signup = false
      @user = User.find(current_user)

      the_groups = []
      
      @user.get_current_manage_groups.each do |group|
        the_groups << group unless the_groups.include?(group)
      end

      @user.groups.each do |group|
        the_groups << group unless the_groups.include?(group)
      end
      
      # the_users = []
      the_users = User.find_all_by_mates(@user)
            
      Escuadra.get_users_escuadras(@the_escuadras, the_users, @cup)
      Escuadra.get_groups_escuadras(@the_escuadras, the_groups, @cup)
			
      @the_escuadras.each {|escuadra| @has_escuadra_for_signup = true}
    end

    unless @has_escuadra_for_signup
      redirect_to @cup 
      return
    end
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

  	# groups or users for cup   
  	if params[:group_ids] or  params[:user_ids]

  		# groups for cup
  		if params[:group_ids]
  			@groups = Group.find(params[:group_ids])
  			@groups.each do |group| 

        the_escuadra = Escuadra.get_the_group_escuadras(group, @cup)

  				if the_escuadra.nil? or the_escuadra.empty?
  					the_escuadra = Escuadra.new
  					the_escuadra.name = group.name
  					the_escuadra.item_id = group.id
  					the_escuadra.item_type = 'Group'
  					the_escuadra.join_escuadra(@cup) if the_escuadra.save	
  				else
  					the_escuadra.join_escuadra(@cup)
  				end

  			end
  		end

  		# users for cup   
  		if params[:user_ids]
  			@users = User.find(params[:user_ids])
  			@users.each do |user| 

        the_escuadra = Escuadra.get_the_user_escuadras(user, @cup)

  				if the_escuadra.nil? or the_escuadra.empty?
  					the_escuadra = Escuadra.new
  					the_escuadra.name = user.name
  					the_escuadra.item_id = user.id
  					the_escuadra.item_type = 'User'
  					the_escuadra.join_escuadra(@cup) if the_escuadra.save
  				else
  					the_escuadra.join_escuadra(@cup)
  				end

  			end
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
