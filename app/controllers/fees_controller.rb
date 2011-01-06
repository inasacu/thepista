class FeesController < ApplicationController
  before_filter :require_user

  before_filter :get_group, :only =>[:new]  
  before_filter :has_manager_access, :only =>[:list, :due, :pending_payment]
  before_filter :has_manager_item_access, :only => [:item_list, :item_complete]
  before_filter :has_fee_group_access, :only =>[:edit, :update]
  before_filter :has_user_access, :only => [:index, :item]

  def index
    store_location
    @the_users = []  
    @the_groups = []
    
    @user.groups.each do |group| 
      if !@user.is_subscriber_of?(group) and get_fee_user(group, @user)
        @the_users << @user 
        @the_groups << group
      else
        @the_users << @user 
        @the_groups << group
      end
    end  

    @users = User.paginate(:all, :conditions => ["id in (?) and archive = false", @the_users], :order => "name", :page => params[:page], :per_page => USERS_PER_PAGE)    
    render :template => 'fees/index'
  end

  def list
    store_location
    @the_users = []
    @the_groups = []
    @the_groups << @group     

    @group.users.each do |user|
      @has_fees = false
      get_fee_user(@group, user)
      @the_users << user if @has_fees
    end
    @users = User.paginate(:all, :conditions => ["id in (?) and archive = false", @the_users], :order => "name", :page => params[:page], :per_page => USERS_PER_PAGE)    
    render :template => 'fees/index'
  end

  def item
    store_location
    @the_users = []  
    @the_groups = []
    
    @user.groups.each do |group| 
      if get_fee_user(group, @user)
        @the_users << @user 
        @the_groups << group
      end
    end  

    @users = User.paginate(:all, :conditions => ["id in (?) and archive = false", @the_users], :order => "name", :page => params[:page], :per_page => USERS_PER_PAGE)    
    render :template => 'fees/index'
  end

  def due
    store_location
    @the_users = []
    @the_groups = []
    @the_groups << @group     

    # @group.all_non_subscribers.each do |user|
    #   @the_users << user if get_fee_user(@group, user)     
    # end
    
    @group.users.each do |user|
      @the_users << user if get_fee_user(@group, user)     
    end
    @users = User.paginate(:all, :conditions => ["id in (?) and archive = false", @the_users], :order => "name", :page => params[:page], :per_page => USERS_PER_PAGE)    
    render :template => 'fees/index'
  end

  def new
    @fee = Fee.new
    @recipients = @group.users

    unless current_user.is_manager_of?(@group) 
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end

    @fee.credit = @group
  end

  def create
    @fee = Fee.new(params[:fee])       
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @fee.item = @group
    @fee.manager_id = current_user.id

    # fee to several users    
    if params[:recipient_ids]
      @recipients = User.find(params[:recipient_ids])
      @fee.debit = @recipients.first
    end

    if @recipients.nil?
      redirect_to :action => "new", :id => @group
      return
    end


    if @fee.save 
      @recipients.each do |recipient|
        @recipient_fee = Fee.new(params[:fee])    
        @recipient_fee.debit = recipient
        @recipient_fee.item = @fee.item
        @recipient_fee.manager_id = @fee.manager_id
        @recipient_fee.save! unless @recipients.first == recipient
      end

      flash[:notice] = I18n.t(:successful_create)
      redirect_to fees_url and return
    else
      render :action => 'new'
    end
  end

  def update
    if @fee.update_attributes(params[:fee])
      flash[:success] = I18n.t(:successful_update)
      redirect_to fees_url and return
    else
      render :action => 'edit'
    end
  end

  private

  def get_group
    # depended on number of groups for current user 
    # a group id is needed
    if current_user.groups.count == 0
      redirect_to :controller => 'groups', :action => 'new' 
      return

    elsif current_user.groups.count == 1 
      @group = current_user.groups.find(:first)

    elsif current_user.groups.count > 1 and !params[:id].nil?
      @group = Group.find(params[:id])

    elsif current_user.groups.count > 1 and params[:id].nil? 
      redirect_to :controller => 'groups', :action => 'index' 
      return
    end
  end

  def has_user_access
    if params[:id]
      @user = User.find(params[:id])
      unless current_user.is_user_manager_of?(@user) or @user == current_user
        flash[:warning] = I18n.t(:unauthorized)
        redirect_to root_url
        return
      end
    else
      redirect_to root_url
      return
    end
  end

  def has_manager_item_access

    if params[:item]      
      case params[:item]
      when "Challenge"
        @item = Challenge.find(params[:id])
        @challenge = Challenge.find(params[:id])
        @users = @challenge.users
      when "Group"
        @item = Group.find(params[:id])
        @group = Group.find(params[:id])
        @users = @group.users
      when "User"
        @item = User.find(params[:id])
        @user = @item
        @users = User.find(:all, :conditions => ['id = ?', @user.id])
      else
      end


      case params[:item]
      when "Challenge", "Group"
        unless current_user.is_manager_of?(@item) 
          flash[:warning] = I18n.t(:unauthorized)
          redirect_to root_url
          return
        end

      when "User"
        if current_user.is_user_manager_of?(@user) or @user == current_user
        else
          flash[:warning] = I18n.t(:unauthorized)
          redirect_to root_url
          return
        end
      end

    else
      redirect_to root_url
      return
    end
  end

  def has_manager_access
    if params[:id]
      @group = Group.find(params[:id]) 

      unless current_user.is_manager_of?(@group) 
        flash[:warning] = I18n.t(:unauthorized)
        redirect_to root_url
        return
      end

    else
      redirect_to root_url
      return
    end
  end

  def has_fee_group_access
    @fee = Fee.find(params[:id])    
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_fee_user(group, user)	
    has_fees = false
    only_payment_due = false
    current_debit, current_crebit, total_debit_amount, total_credit_amount, fee_debit_id = 0.0,  0.0,  0.0,  0.0,  0
    
    fees = []
    payments = []
    
    Fee.debit_user_item_schedule(user, group, fees, user.is_subscriber_of?(group))
    Payment.debit_user_item_schedule(user, group, payments)	

    debit_fee = Fee.sum_debit_amount_fee(fees)
    total_debit_amount = debit_fee.debit_amount

    debit_payment = Payment.sum_debit_payment(payments)
    total_credit_amount = debit_payment.debit_amount
    
    @has_fees = (total_debit_amount > 0.0)
    @has_fees = total_credit_amount > 0.0 unless @has_fees
    total_owe = total_debit_amount.to_f - total_credit_amount.to_f
    payment_due = total_owe > 0.0

    return payment_due
  end

end