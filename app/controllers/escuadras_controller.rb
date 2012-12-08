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

		if @cup.official

			@escuadras = Escuadra.find(:all, :conditions => ["official = ? and item_type = 'Escuadra' and id not in (select escuadra_id from cups_escuadras where cup_id = ?)", @cup.official, @cup])
			@escuadras.each {|escuadra| @the_escuadras << escuadra}

		else	

			@has_escuadra_for_signup = false
			@user = User.find(current_user)
			@current_manage_groups = @user.get_current_manage_groups

			@current_escuadras = Escuadra.find(:all, :conditions => ["archive = false and escuadras.id in (select escuadra_id from cups_escuadras where cups_escuadras.archive = false and cups_escuadras.cup_id = ?)", @cup])

			@current_manage_groups.each do |group| 
				is_item_available = false
				@current_escuadras.each {|escuadra| is_item_available = (escuadra.item_type == 'Group' and escuadra.item == group) ? true : is_item_available }
				@the_escuadras << group unless is_item_available
			end

			is_item_available = false
			@current_escuadras.each {|escuadra| is_item_available = (escuadra.item_type == 'User' and escuadra.item == @user) ? true : is_item_available }
			@the_escuadras << @user unless is_item_available

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

					the_escuadra = Escuadra.find(:first, :conditions => ["official = ? and item_id = ? and item_type='Group'", @cup.official, group])
					if the_escuadra.nil?

						new_escuadra = Escuadra.new
						new_escuadra.name = group.name
						new_escuadra.photo = group.photo
						new_escuadra.item_id = group.id
						new_escuadra.item_type = 'Group'

						if new_escuadra.save!
							new_escuadra.join_escuadra(@cup)						
						end

					else
						the_escuadra.join_escuadra(@cup)

					end

				end
			end

			# users for cup   
			if params[:user_ids]
				@users = User.find(params[:user_ids])
				@users.each do |user| 

					the_escuadra = Escuadra.find(:first, :conditions => ["official = ? and item_id = ? and item_type='User'", @cup.official, user])
					if the_escuadra.nil?

						new_escuadra = Escuadra.new
						new_escuadra.name = user.name
						new_escuadra.photo = user.photo
						new_escuadra.item_id = user.id
						new_escuadra.item_type = 'User'

						if new_escuadra.save!
							new_escuadra.join_escuadra(@cup)						
						end

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
