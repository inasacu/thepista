class SchedulesController < ApplicationController
  # GET /schedules
  # GET /schedules.xml
  def index
    @schedules = Schedule.paginate(:per_page => 10, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.xml
  def show
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/signup
  # GET /schedules/signup.xml
  def signup
    @schedule = Schedule.new
    respond_to do |format|
      format.html # signup.html.erb
      format.xml  { render :xml => @schedule }
    end
  end  

  # GET /schedules/new
  # GET /schedules/new.xml
  def new
    @schedule = Schedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/1/edit
  def edit
    @schedule = current_schedule
  end

  # POST /schedules
  # POST /schedules.xml
  def create
    @schedule = Schedule.new(params[:schedule])

    @schedule.save do |result|
      if result
        # flash[:notice] = control_action_label('notice')
        flash[:notice] = I18n.t(:successful_signup)
        redirect_to root_url
      else
        render :action => 'signup'
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.xml
  def update
    @schedule = current_schedule

    @schedule.attributes = params[:schedule]
    @schedule.save do |result|
      if result
        # flash[:notice] = control_action_label('notice')
        flash[:notice] = I18n.t(:successful_update)
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end
  end
end


