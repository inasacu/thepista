class FeesController < ApplicationController
  before_filter :require_user

  before_filter :has_manager_access, :only =>[:list, :complete]
  before_filter :has_fee_group_access, :only =>[:edit, :update]
  before_filter :has_user_access, :only => [:index]

  def index
    @users = [] 
    @users << @user.id      
    @debit_payment = Payment.debit_amount(@users, 'User')
    @credit_payment = Payment.credit_amount(@users, 'User')

    @groups = []
    @user.groups.each do |group|
      @groups << group.id 
    end

    @debit_fee = Fee.debit_amount(@users, @groups)      
    @fees = Fee.debit_fees(@users, @groups, params[:page])
    @payments = Payment.credit_payments(@users, @groups, params[:page])

    render :template => '/fees/index'
  end

  def list
    @groups = []
    @groups << @group.id

    @users = [] 
    @subscriptions = []
    @group.the_subscriptions.each do |subs|
      @subscriptions << subs.user_id 
    end 

    # users who do not have subscriptions, also remove users who owe no quantities to team
    @group.users.each do |user|
      unless @subscriptions.include?(user.id)

        @temp_users = []
        @temp_users << user.id

        @debit_payment = Payment.debit_amount(@temp_users, 'User')
        @credit_payment = Payment.credit_amount(@temp_users, 'User')
        @debit_fee = Fee.debit_amount(@temp_users, @groups)

        @users << user.id unless @debit_fee.debit_amount.to_f <= (@debit_payment.debit_amount.to_f + @credit_payment.credit_amount.to_f)

      end
    end

    @debit_payment = Payment.debit_amount(@users, 'User')
    @credit_payment = Payment.credit_amount(@users, 'User')
    @debit_fee = Fee.debit_amount(@users, @groups)
    @fees = Fee.debit_fees(@users, @groups, params[:page])
    @payments = Payment.credit_payments(@users, @groups, params[:page])

    render :template => '/fees/index'
  end

  def complete
    @groups = []
    @groups << @group.id

    @users = [] 
    @group.users.each do |user|
      @users << user.id
    end 

    @debit_payment = Payment.debit_amount(@users, 'User')
    @credit_payment = Payment.credit_amount(@users, 'User')
    @debit_fee = Fee.debit_amount(@users, @groups)
    @fees = Fee.debit_fees(@users, @groups, params[:page])
    @payments = Payment.credit_payments(@users, @groups, params[:page])

    render :template => '/fees/index'
  end

  def new
    @fee = Fee.new
    return unless (params[:group_id])
    @group = Group.find(params[:group_id])

    unless current_user.is_manager_of?(@group) 
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end

    @fee.credit = @group

    # get subscription and non subscription users
    @non_subscriptions = []
    @subscriptions = []
    @group.the_subscriptions.each do |subs|
      @subscriptions << subs.user_id 
    end 

    # users who do not have subscriptions
    @group.users.each do |user|
      @non_subscriptions << user.id unless @subscriptions.include?(user.id)
    end
    
    @user_subscription = User.find(:all, :conditions => ["id in (?)", @subscriptions], :order => 'name')
    @user_non_subscription = User.find(:all, :conditions => ["id in (?)", @non_subscriptions], :order => 'name')


    respond_to do |format|
      format.html
    end
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

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    # fee to several users    
    if params[:recipient_ids]
      @recipients = User.find(params[:recipient_ids])
      @fee.debit = @recipients.first
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

end