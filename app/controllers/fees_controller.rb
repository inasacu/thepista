class FeesController < ApplicationController
  before_filter :require_user

  def index
    if params[:id]
      @user = User.find(params[:id])

      unless current_user.is_user_manager_of?(@user) or @user == current_user
        flash[:warning] = I18n.t(:unauthorized)
        redirect_to root_url
        return
      end

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
    else
      redirect_to root_url
      return
    end

    render :template => '/fees/index'
  end

  def list
    if params[:id]
      @group = Group.find(params[:id])

      unless current_user.is_manager_of?(@group) 
        flash[:warning] = I18n.t(:unauthorized)
        redirect_to root_url
        return
      end

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
    else
      redirect_to root_url
      return
    end
        
    render :template => '/fees/index'
  end

  def complete
    if params[:id]
      @group = Group.find(params[:id])

      unless current_user.is_manager_of?(@group) 
        flash[:warning] = I18n.t(:unauthorized)
        redirect_to root_url
        return
      end

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
    else
      redirect_to root_url
      return
    end
        
    render :template => '/fees/index'
  end

  def new
    @fee = Fee.new
    return unless (params[:group_id])
    @group = Group.find(params[:group_id])

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @fee.credit = @group

    respond_to do |format|
      format.html
    end
  end

  def create
    @fee = Fee.new(params[:fee])       
    # @group = Group.find(@fee.item_id)
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

  def edit
    @fee = Fee.find(params[:id])    
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

  end

  def update
    @fee = Fee.find(params[:id])   
    # @group = Group.find(@fee.item_id)
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @fee.update_attributes(params[:fee])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to fees_url and return
    else
      render :action => 'edit'
    end
  end

  def destroy
    @fee = Fee.find(params[:id])   
    # @group = Group.find(@fee.item_id)
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @fee.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to fees_url
  end
end