class PaymentsController < ApplicationController
  before_filter :require_user

  before_filter :get_fee, :only =>[:new]
  before_filter :has_manager_access, :only =>[:edit, :update, :destroy]

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
      case @fee.credit_type
      when "Group"
        @item = Group.find(@fee.credit_id) 
      when "Challenge"
        @item = Challenge.find(@fee.credit_id)
      else
      end

      @users = User.find(:first, :conditions => ["id = ?", @fee.debit_id])

      fees = []
      payments = []

      Fee.debit_user_item_schedule(@users, @item, fees, @users.is_subscriber_of?(@item))
      Payment.debit_user_item_schedule(@users, @item, payments)

      debit_amount = 0.0
      credit_amount = 0.0

      fees.each{|fee| debit_amount += fee.debit_amount}
      payments.each{|payment| credit_amount += payment.debit_amount}

      @payment.fee_id = fees.first.id
      @payment.concept = fees.first.concept
      @payment.debit_amount = debit_amount.to_f - credit_amount.to_f      
    end
    render @the_template  
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment_credit = Payment.new(params[:payment])

    @fee = Fee.find(@payment.fee_id)

    case @fee.credit_type
    when "Group"
      @item = Group.find(@fee.credit_id) 
    when "Challenge"  
      @item = Challenge.find(@fee.credit_id)
    else
    end

    unless current_user.is_manager_of?(@item)
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
      # redirect_to fees_url(:id => @user) and return
      redirect_back_or_default('/index')
      # redirect_to root_url and return
    else
      render :action => 'new', :id => @payment
    end
  end

  def edit
    set_the_template('payments/new')
    render @the_template
  end

  def update
    if @payment.update_attributes(params[:payment])
      flash[:success] = I18n.t(:successful_update)
      redirect_to fees_url and return
    else
      render :action => 'edit'
    end
  end

  def destroy
    @payment.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to fees_url
  end

  private

  def get_fee    
    unless params[:id]
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end

    @fee = Fee.find(params[:id])   
    case @fee.credit_type
    when "Group"
      @item = Group.find(@fee.credit_id) 
    when "Challenge"
      @item = Challenge.find(@fee.credit_id)
    end

    unless current_user.is_manager_of?(@item)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end

  end

  def has_manager_access
    @payment = Payment.find(params[:id])

    case @payment.credit_type
    when "Group"
      @item = Group.find(@payment.fee.credit_id) 
    when "Challenge"
      @item = Challenge.find(@payment.fee.credit_id)
    end

    unless current_user.is_manager_of?(@item)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

end