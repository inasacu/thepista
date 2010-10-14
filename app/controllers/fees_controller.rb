class FeesController < ApplicationController
  before_filter :require_user

  before_filter :get_group, :only =>[:new]
  before_filter :has_manager_access, :only =>[:list, :complete]
  before_filter :has_manager_item_access, :only => [:item_list, :item_complete]
  before_filter :has_fee_group_access, :only =>[:edit, :update]
  before_filter :has_user_access, :only => [:index, :item]

  def index
    @users = [] 
    @groups = []
    @schedules = []
    @the_fees = []
    @the_payments = []
    
    @users << @user
    
    @user.groups.each do |group|
      @groups << group      
      Schedule.match_participation(group, @users, @schedules) unless @user.is_subscriber_of?(group)
    end  
    
    get_all_fees
    render :template => '/fees/index'
  end
  
  def item
    @users = [] 
    @groups = []
    @schedules = []
    @the_fees = []
    @the_payments = []
    
    @users << @user
    
    @user.groups.each do |group|
      @groups << group      
      Schedule.match_participation(group, @users, @schedules) unless @user.is_subscriber_of?(group)
    end

    get_all_payments
    render :template => '/fees/index'
  end

  def list
    @users = [] 
    @groups = []
    @schedules = []
    @the_fees = []
    @the_payments = []

    @groups << @group

    @group.users.each do |user|
      @users << user
    end
    Schedule.match_participation(@group, @users, @schedules)    
    
    get_all_fees
    render :template => '/fees/index'
  end
  
  def item_list
    @users = [] 
    @groups = []
    @schedules = []
    @the_fees = []
    @the_payments = []

    @groups << @group

    @group.users.each do |user|
      @users << user
    end

    get_all_payments
    render :template => '/fees/index'
  end

  def complete
    @users = [] 
    @groups = []
    @schedules = []
    @the_fees = []
    @the_payments = []

    @groups << @group

    @group.users.each do |user|
      @users << user unless user.is_subscriber_of?(@group)
    end
    Schedule.match_participation(@group, @users, @schedules)    
    
    get_all_fees
    render :template => '/fees/index'
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
      flash[:notice] = I18n.t(:successful_update)
      redirect_to fees_url and return
    else
      render :action => 'edit'
    end
  end

  # def destroy
  #   @fee.destroy
  #   flash[:notice] = I18n.t(:successful_destroy)
  #   redirect_to fees_url
  # end

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
  
  def get_all_fees    
    Fee.debits_credits_items_fees(@users, @groups, @groups, @the_fees) 
    Fee.debits_credits_items_fees(@users, @groups, @schedules, @the_fees)
    @debit_fee = Fee.sum_debit_amount_fee(@the_fees)    
    
    Payment.debits_credits_items_payments(@users, @groups, @groups, @the_payments) 
    Payment.debits_credits_items_payments(@users, @groups, @schedules, @the_payments)    
    @debit_payment, @credit_payment = Payment.sum_debit_amount_payment(@the_payments)
    
    @fees = Fee.page_all_fees(@the_fees, params[:page])  
  end
  
  def get_all_payments    
    Fee.debits_credits_items_fees(@users, @groups, @groups, @the_fees) 
    Fee.debits_credits_items_fees(@users, @groups, @schedules, @the_fees)
    @debit_fee = Fee.sum_debit_amount_fee(@the_fees)
    
    Payment.debits_credits_items_payments(@users, @groups, @groups, @the_payments) 
    Payment.debits_credits_items_payments(@users, @groups, @schedules, @the_payments)    
    @debit_payment, @credit_payment = Payment.sum_debit_amount_payment(@the_payments) 
    
    @payments = Payment.page_all_payments(@the_payments, params[:page])
  end

end