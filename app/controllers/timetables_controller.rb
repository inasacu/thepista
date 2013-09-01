class TimetablesController < ApplicationController
  before_filter :require_user

  before_filter   :get_installation_or_group,    :only => [:new]
  before_filter   :get_timetable,       					:only => [:edit, :update]

  def index  
    # store_location
    # @installations = Installation.current_installations(@venue, params[:page])
    # render @the_template
 		redirect_to :root
		return
  end

  def show
    redirect_to show_installation_url(:id => @installation)
    render @the_template
  end

	def new
		@timetable = Timetable.new

		if @installation 
			@timetable.installation = @installation
			@timetable.starts_at = @installation.starts_at
			@timetable.ends_at = @installation.ends_at
			@timetable.timeframe = @installation.timeframe

			@previous_timetable = Timetable.find(:first, :conditions => ["id = (select max(id) from timetables where installation_id = ?) ", @installation])    
			unless @previous_timetable.nil?     
				@timetable.type_id = @previous_timetable.type_id
				@timetable.starts_at = @previous_timetable.starts_at
				@timetable.ends_at = @previous_timetable.ends_at
				@timetable.timeframe = @previous_timetable.timeframe
			end
		end

		if @group 
			@timetable.item_id = @group.id
			@timetable.item_type = 'Group'
			@timetable.starts_at = @group.item.starts_at
			@timetable.ends_at = @group.item.starts_at + @group.item.timeframe.hours
			@timetable.timeframe = @group.item.timeframe

			@previous_timetable = Timetable.find(:first, :conditions => ["id = (select max(id) from timetables where item_id = ? and item_type = 'Group') ", @group])    
			unless @previous_timetable.nil?     
				@timetable.type_id = @previous_timetable.type_id
				@timetable.starts_at = @previous_timetable.starts_at + @previous_timetable.timeframe.hours
				@timetable.ends_at = @previous_timetable.ends_at + @previous_timetable.timeframe.hours
				@timetable.timeframe = @previous_timetable.timeframe
			end
		end

		# render @the_template
	end

  def create
    @timetable = Timetable.new(params[:timetable])  
		@group = Group.find(@timetable.item_id) if @timetable.item_type = 'Group' 

    if @timetable.save 
      successful_create

      redirect_to @timetable.installation and return unless @timetable.installation.nil?
	    redirect_to @timetable.item and return unless @timetable.item_type.nil?

    else
      render :action => 'new'
    end
  end

  def edit
    set_the_template('timetables/new')
    render @the_template
  end

  def update
    if @timetable.update_attributes(params[:timetable])  
      controller_successful_update
      redirect_to @installation
    else
      render :action => 'edit'
    end
  end

  def set_copy_timetable
    @installation = Installation.find(params[:id])
    @current_installation = Installation.find(params[:current_id])

    unless @installation.nil?
      @the_timetables = Timetable.installation_timetable(@installation)

      @the_timetables.each do |the_timetable|
        @timetable = Timetable.new
        @timetable.type_id = the_timetable.type_id
        @timetable.starts_at = the_timetable.starts_at
        @timetable.ends_at = the_timetable.ends_at
        @timetable.timeframe = the_timetable.timeframe
        @timetable.installation_id = @current_installation.id
        @timetable.save
      end

      controller_successful_update
      redirect_to @current_installation
      return
    end
    redirect_to root_url
  end

  private

  def get_timetable
    @timetable = Timetable.find(params[:id]) if params[:id]

		
    @installation = @timetable.installation
    @venue = @installation.venue

    unless is_current_manager_of(@venue)
      warning_unauthorized
      redirect_back_or_default('/index')
      return
    end
  end

	def get_installation_or_group

		if params[:installation_id]
			@installation = Installation.find(params[:installation_id]) 
			@installation = Installation.find(params[:timetable][:installation_id]) if params[:timetable]
			@venue = @installation.venue

			unless is_current_manager_of(@venue)
				warning_unauthorized
				redirect_back_or_default('/index')
				return
			end
		end

		if params[:group_id]
			@group = Group.find(params[:group_id]) 
			# @group = Group.find(params[:timetable][:group_id]) if params[:timetable]

			unless is_current_manager_of(@group)
				warning_unauthorized
				redirect_back_or_default('/index')
				return
			end
		end

		if !params[:installation_id] and !params[:group_id]
			warning_unauthorized
			redirect_back_or_default('/index')
		end

	end

end

