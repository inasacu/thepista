class PaymentsController < ApplicationController
  before_filter :require_user
  
  def index
    @payments = Payment.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @payments = Payment.find(params[:id])
  end
  
  def new
    @payments = Payment.new
  end
  
  def create
    @payments = Payment.new(params[:payments])
    if @payments.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @payments
    else
      render :action => 'new'
    end
  end
  
  def edit
    @payments = Payment.find(params[:id])
  end
  
  def update
    @payments = Payment.find(params[:id])
    if @payments.update_attributes(params[:payments])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @payments
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @payments = Payment.find(params[:id])
    @payments.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to fees_url
  end
end


# 
# class PaymentsController < ApplicationController
#   before_filter :login_required
#   
#   def index
#     if (params[:user_id])
#       @user = User.find(params[:user_id])      
#       @payments = Payment.get_credit_payments(@user,false, params[:page])
# 
#       respond_to do |format|
#         format.html 
#       end
#     end
# 
#     if (params[:group_id])
#       @group = Group.find(params[:group_id])      
#       @payments = Payment.get_credit_payments(@group, false, params[:page])
# 
#       respond_to do |format|
#         format.html 
#       end
#     end
#   end
# 
#   def list
#     @payments = Payment.find(:all)
#     render :template => '/payments/index'
#     
#     respond_to do |format|
#       format.html 
#     end
#   end 
#   
#   def show
#     @payment = Payment.find(params[:id])
#     
#     respond_to do |format|
#       format.html 
#     end
#   end 
#   
#   def get_fee_objects(fee)
#     case @fee.debit.class.to_s
#     when 'User'
#       @debit_object = User.find(@fee.debit_id)
#       
#       case @fee.credit.class.to_s
#       when 'Group'
#         @credit_object = Group.find(@fee.credit_id)
#       when 'Match'
#         @credit_object = Match.find(@fee.credit_id).schedule.group
#       when 'Marker'
#         @credit_object = Marker.find(@fee.credit_id)
#       end
#       
#     when 'Group'  
#       @debit_object = Group.find(@fee.debit_id)
#       
#       case @fee.credit.class.to_s
#       when 'Group'
#         @credit_object = Group.find(@fee.credit_id)
#       when 'Match'
#         @credit_object = Match.find(@fee.credit_id).schedule.group
#       when 'Marker'
#         @credit_object = Marker.find(@fee.credit_id)
#       end
#     end
#     return @debit_object, @credit_object
#   end
#   
# 
#   def new
#     @fee = Payment.find(params[:fee_id])
#     @payment = Payment.new
#     
#     @debit, @credit = get_fee_objects(@fee)
#     
#     if current_user.is_manager_of?(@debit) or current_user.is_manager_of?(@credit)      
#       fee = Payment.debit_amount(@debit)
#       payment = Payment.actual_payment(@debit)
#       
#       @payment = Payment.new 
#       @payment.concept = @fee.concept
#       @payment.debit_amount = fee.debit_amount.to_f - payment.actual_payment.to_f
#       @payment.credit_amount = 0.0
# 
#       respond_to do |format|
#         format.html 
#       end
#       
#      end
#   end
#     
#   def create
#     @debit = Payment.new(params[:payment])
#     @credit = Payment.new(params[:payment])
#     @fee = Payment.find(params[:fee][:id]) unless params[:fee][:id].nil?     
#     
#     @debit_object, @credit_object = get_fee_objects(@fee)
#     
#     if current_user.is_manager_of?(@debit_object) or current_user.is_manager_of?(@credit_object)
#                   
#          @debit.manager_id = current_user.id
#          @debit.fee_id = @fee.id
#          @debit.debit_id = @debit_object.id
#          @debit.debit_type = @debit_object.class.to_s
#          @debit.credit_id = @credit_object.id
#          @debit.credit_type = @credit_object.class.to_s         
#          @debit.credit_amount = 0
#          
#          @credit.manager_id = current_user.id
#          @credit.fee_id = @fee.id
#          @credit.debit_id = @debit_object.id
#          @credit.debit_type = @debit_object.class.to_s
#          @credit.credit_id = @credit_object.id
#          @credit.credit_type = @credit_object.class.to_s
#          @credit.debit_amount = @debit.credit_amount
#          @credit.credit_amount = @debit.debit_amount
#                 
#          if @debit.save and @credit.save
#            
#            if @debit.debit_amount == @fee.debit_amount
#              flash[:notice] = "perfect - payed total balance"
#            elsif @debit.debit_amount < @fee.debit_amount
#              flash[:notice] = "still missing - to cover total balance"
#            elsif @debit.debit_amount > @fee.debit_amount
#              flash[:notice] = "perfect - but you payed over total balance"
#            end
#               
#            respond_to do |format|
#              format.html { redirect_back_or_default('/') and return}
#            end           
#           else
#             flash[:notice] = :missing_information.l
#             redirect_to :action => 'new', :fee_id => @fee.id and return
#          end
#         # flash[:notice] = :change_wo_access.l 
#         # redirect_to :action => 'new', :fee_id => @fee.id 
#     end    
#   
#      rescue ActiveRecord::RecordNotSaved
#            flash[:notice] = :missing_information.l
#            redirect_to payments_url and return
#   end   
# end
