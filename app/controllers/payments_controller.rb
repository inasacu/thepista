class PaymentsController < ApplicationController
  before_filter :require_user


  def index
    if (params[:id]) 
      @user = User.find(params[:id])      
    else
      @user = current_user
    end
  
    @payments = Payment.current_payments(@user, page=1)
    @debit_payment = Payment.debit_payment(@user)
    @credit_payment = Payment.credit_payment(@user)
  end

  def new
    @payment = Payment.new
    return unless (params[:fee_id])
    
    @fee = Fee.find(params[:fee_id])
    # @group = Group.find(@fee.item_id)
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"
    
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    @user = User.find(@fee.debit_id)
    @debit_payment = Payment.debit_payment(@user)
    
    @payment.concept = @fee.concept
    @payment.debit_amount = @fee.debit_amount.to_f - @debit_payment.actual_payment.to_f
    @payment.description = @fee.description
  end

  def create
    @payment_debit = Payment.new(params[:payment])
    @payment_credit = Payment.new(params[:payment])
    
    @fee = Fee.find(params[:fee][:id])
    # @group = Group.find(@fee.item_id)
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"
    
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    @payment_debit.manager_id = current_user.id
    @payment_debit.credit = @fee.credit
    @payment_debit.debit = @fee.debit
    @payment_debit.item = @fee.item
    @payment_debit.fee_id = @fee.id
    @payment_debit.credit_amount = 0.0
    
    @payment_credit.manager_id = current_user.id
    @payment_credit.debit = @fee.debit
    @payment_credit.credit = @fee.credit
    @payment_credit.item = @fee.item 
    @payment_credit.fee_id = @fee.id
    @payment_credit.debit_amount = 0.0
    @payment_credit.credit_amount = @payment_debit.debit_amount
    
    if @payment_debit.save and @payment_credit.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to payments_url and return
    else
      render :action => 'new'
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    # @group = Group.find(@payment.fee.item_id)
    @group = Group.find(@payment.fee.credit_id) if @payment.credit_type == "Group"
    
    
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def update
    @payment = Payment.find(params[:id])
    # @group = Group.find(@payment.fee.item_id)
    @group = Group.find(@payment.fee.credit_id) if @payment.credit_type == "Group"
    
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    if @payment.update_attributes(params[:payment])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to payments_url and return
    else
      render :action => 'edit'
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    # @group = Group.find(@payment.fee.item_id)
    @group = Group.find(@payment.fee.credit_id) if @fee.credit_type == "Group"
    
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    @payment.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to payments_url and return
  end
end