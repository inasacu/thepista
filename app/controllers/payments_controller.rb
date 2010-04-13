class PaymentsController < ApplicationController
  before_filter :require_user

  before_filter :get_fee, :only =>[:new]
  before_filter :has_manager_access, :only =>[:edit, :update]

  def index
    if (params[:id]) 
      @user = User.find(params[:id])      
    else
      @user = current_user
    end
    redirect_to fees_url(:id => @user) and return
  end

  def list
    if (params[:id]) 
      @group = Group.find(params[:id])      
    else
      redirect_to root_url
      return
    end
    redirect_to list_fees_url(:id => @group) and return
  end

  def new
    @payment = Payment.new

    @fee = @payment.fee unless @payment.fee.nil?

    if @fee
      @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"
      @user = User.find(@fee.debit_id)
      
      @users = [] 
      @users << @user.id 

      @groups = [] 
      @groups << @group.id

      @debit_fee = Fee.debit_amount(@users, @groups)
      @debit_payment = Payment.debit_amount(@users, 'User')

      @payment.concept = @fee.concept
      @payment.debit_amount = @debit_fee.debit_amount.to_f - @debit_payment.debit_amount.to_f
      @payment.description = @fee.description
      @payment.fee_id = @fee.id
    end
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment_credit = Payment.new(params[:payment])

    @fee = Fee.find(@payment.fee_id)
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"
    @user = User.find(@fee.debit_id) if @fee.debit_type == 'User'

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end

    @payment.manager_id = current_user.id
    @payment.credit = @fee.credit
    @payment.debit = @fee.debit
    @payment.item = @fee.item
    @payment.fee_id = @fee.id
    @payment.credit_amount = 0.0

    @payment_credit.manager_id = current_user.id
    @payment_credit.debit = @fee.debit
    @payment_credit.credit = @fee.credit
    @payment_credit.item = @fee.item 
    @payment_credit.fee_id = @fee.id
    @payment_credit.debit_amount = 0.0
    @payment_credit.credit_amount = @payment.debit_amount

    if @payment.save and @payment_credit.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to fees_url(:id => @user) and return
    else
      render :action => 'new', :id => @payment
    end
  end

  def update
    if @payment.update_attributes(params[:payment])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to fees_url and return
    else
      render :action => 'edit'
    end
  end

  private

  def get_fee    
    unless params[:id]
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
    
    @fee = Fee.find(params[:id])    
    @group = Group.find(@fee.credit_id) if @fee.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

  def has_manager_access
    @payment = Payment.find(params[:id])
    @group = Group.find(@payment.fee.credit_id) if @payment.credit_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

end