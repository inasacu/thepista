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

      @debit_payment = Payment.debit_payment(@user)
      @credit_payment = Payment.credit_payment(@user)

      @groups = []
      @user.groups.each do |group|
        @groups << group.id if current_user.is_user_manager_group(@user, group)
      end
      
      @fee = Fee.debit_amount(@user, @groups)
      @fees = Fee.get_debit_fees(@user, @groups, params[:page])
    else
      redirect_to root_url
    end

    respond_to do |format|
      format.html 
    end 
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
    @group = Group.find(@fee.credit_id)
    
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
    
    @group = Group.find(@fee.item_id)
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
  end

  def update
    @fee = Fee.find(params[:id])
    @group = Group.find(@fee.item_id)
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
    @group = Group.find(@fee.item_id)
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