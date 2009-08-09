class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.paginate(:per_page => 10, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/signup
  # GET /messages/signup.xml
  def signup
    @message = Message.new
    respond_to do |format|
      format.html # signup.html.erb
      format.xml  { render :xml => @message }
    end
  end  

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = current_message
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    @message.save do |result|
      if result
        # flash[:notice] = control_action_label('notice')
        flash[:notice] = I18n.t(:successful_signup)
        redirect_to root_url
      else
        render :action => 'signup'
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = current_message

    @message.attributes = params[:message]
    @message.save do |result|
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

