class FeesController < ApplicationController
  before_filter :require_user
  
  
    def index
      # if (params[:user_id])
      if current_user
        
        @fee = Fee.paginate(:per_page => 10, :page => params[:page])
  
        # @user = User.find(params[:user_id]) 
        @user = current_user
        @fees = Fee.get_debit_fees(@user, false, false, params[:page])   
  
        @fee = Fee.debit_amount(@user)
        @payment = Payment.actual_payment(@user)
  
        if @payment.actual_payment.to_f == @fee.debit_amount.to_f
          @payment_in_full = I18n.t(:payment_full)
        elsif @payment.actual_payment.to_f < @fee.debit_amount.to_f
          @payment_in_full = I18n.t(:payment_less_than)
        elsif @payment.actual_payment.to_f > @fee.debit_amount.to_f
          @payment_in_full = I18n.t(:payment_greater_than)
        end                
  
      end
      
      # if (params[:group_id])
      #   
      #   @group = Group.find(params[:group_id])     
      #   @fee = Fee.get_debit_fees(@group, false, false, params[:page]) 
      #   
      #   @fee = Fee.debit_amount(@group)
      #   @payment = Payment.actual_payment(@group, 'Group')
      #   
      #   if @payment.actual_payment.to_f == @fee.debit_amount.to_f
      #     @payment_in_full = :full_payment.l
      #   elsif @payment.actual_payment.to_f < @fee.debit_amount.to_f
      #     @payment_in_full = :less_than_payment.l
      #   elsif @payment.actual_payment.to_f > @fee.debit_amount.to_f
      #     @payment_in_full = :greater_than_payment.l
      #   end                
      #   
      #  end
      
      respond_to do |format|
        format.html 
      end             
                             
    end
  
  
  
  # def index
  #   @fee = Fee.paginate(:per_page => 10, :page => params[:page])
  # end
  
  def show
    @fee = Fee.find(params[:id])
  end
  
  def new
    @fee = Fee.new
  end
  
  def create
    @fee = Fee.new(params[:fees])
    if @fee.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @fee
    else
      render :action => 'new'
    end
  end
  
  def edit
    @fee = Fee.find(params[:id])
  end
  
  def update
    @fee = Fee.find(params[:id])
    if @fee.update_attributes(params[:fees])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @fee
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @fee = Fee.find(params[:id])
    @fee.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to fees_url
  end
end




#   before_filter :get_fee, :only => [:show, :edit, :update, :destroy, :team_roster, :team_no_show]
# 

# 
#   # def list    
#   #   @fee = Fee.paginate(:all, 
#   #                          :joins => "LEFT JOIN users on users.id = fees.user_id",                           
#   #                          :conditions => ["fees.user_id > 0 and fees.group_id in (?) and fees.season_payed = ? and fees.archive = false", current_user.groups, false],
#   #                          :order => 'group_id, created_at DESC, users.name', :page => params[:page])
#   #   render :template => '/fees/index'
#   # end
# 
#   def new    
#     # depended on number of groups for current user 
#     # a group id is needed
#     if current_user.groups.count == 0
#       flash[:notice] = :add_fee_requires_group.l
#       redirect_to :controller => 'groups', :action => 'new' 
#       return
# 
#     elsif current_user.groups.count == 1 
#       @group = current_user.groups.find(:first)
# 
#     elsif current_user.groups.count > 1 and !params[:id].nil?
#       @group = Group.find(params[:id])
# 
#     elsif current_user.groups.count > 1 and params[:id].nil? 
#       redirect_to :controller => 'groups', :action => 'index' 
#       return
# 
#     end
#     
#     # editing is limited to administrator or creator
#     if current_user.is_manager_of?(@group)  
#       @fee = Fee.new
#       @fee.group_id = @group.id
#       @recipients = current_user.find_group_mates(@group)
# 
#       @lastFee = Fee.find(:first, :conditions => ["id = (select max(id) from fees where group_id = ? and user_id > 0) ", @group.id])    
#       if !@lastFee.nil?
#         @fee = @lastFee 
#         @fee.debit_amount = @lastFee.debit_amount
#       end
#     end
#   end
# 
#   def create
#     @group = Group.find(params[:fee][:group_id]) unless params[:fee][:group_id].nil?
# 
#     # permit "manager of :group or creator of :group or maximo", :group => @group do
#     if current_user.is_manager_of?(@group)
#       if params[:recipient_ids]
#         @recipients = User.find(params[:recipient_ids])
# 
#         unless @recipients.nil?
#            @recipients.each do |recipient| 
#              
#              @fee = Fee.new(params[:fee])
#              @fee.debit_id = recipient.id
#              @fee.debit_type = recipient.class.to_s
#              
#              @fee.credit_id = @group.id
#              @fee.credit_type = @group.class.to_s
#              
#              @fee.manager_id = current_user.id
#              @fee.save!
# 
#            end
#           
#            respond_to do |format|
#              flash[:success] = "#{:fee.l} #{:created.l}"
#              format.html { redirect_to fees_url(:group_id => @group) and return}
#            end
#          
#         else        
#            redirect_to :action => 'new' and return
#         end
#       end
#     end
#   end
# 
#   def edit 
#     # editing is limited to the manager, creator, maximo
#     permit "manager of :group or creator of :group or maximo", :group => @fee.group do
#       render :template => '/fees/edit' 
#     end
#   end
# 
#   def update  
#     # updating is limited to the manager, creator, maximo
#     permit "manager of :group or creator of :group or maximo", :group => @fee.group do
#       @fee.attributes = params[:fee] 
#       if @fee.save
#         @fee.create_fee_details
#         redirect_to :action => 'show', :id => @fee
#         return
#       else
#         render :template =>  '/fees/edit'
#       end
#     end 
#   end
# 
#   def destroy    
#     #    @fee = Fee.find(params[:id])
#     permit "manager of :group or creator of :group or maximo", :group => @fee.group do      
#       # this code is to remove results from scorecard based on this fee
#       @fee.played = false
#       @fee.save
# 
#       @fee.matches.each do |match|
#         match.group_score, match.invite_score = nil, nil
#         match.played = false
#         match.one_x_two = "" 
#         match.user_x_two = "X" 
#         match.save! 
#         Scorecard.update_user_scorecard(match, @fee)
#       end
#                   
#       Post.find_by_topic_id(self.forum.topics.first.id).destroy      
#       Topic.find_by_forum_id(self.forum.id).destroy
#       Forum.find_by_fee_id(self.id).destroy
#       
#       @fee.destroy
#       flash.now[:notice] = "#{:fee.l} #{:deleted.l}"
#       redirect_to :action => 'index'  
#     end 
#   end
# 
#   private
#   def get_fee
#     @fee = Fee.find(params[:id])
#   end
#   
#   
# end
# 
#   
#   
#   
#   
#   
#   
# #   before_filter :login_required
# #   #permit "maximo"
# #   
# #   def index
# #     @fee = Fee.paginate(:all, 
# #                           :conditions => ["user_id = ?", current_user.id],
# #                           :order => 'group_id, created_at DESC', :page => params[:page])
# #   end
# #   
# #   def new
# #     @fee = Fee.new     
# #     @group = current_user.groups.find(:first)
# #     @recipients = current_user.find_group_mates(@group)    
# #   end
# #   
# #  #  def create
# #  #    @fee = Fee.new(params[:fee])         
# #  #    if @fee.save
# #  #      redirect_to :action => 'index'
# #  #    else
# #  #      render :action => 'new'
# #  #    end
# #  #  end  
# #  #  
# #  # def new_user_fee
# #  #   @fee = Fee.new
# #  #   @user = User.find(params[:id])
# #  #   @group = Group.find(:first, :conditions => ["id = 1"])
# #  # end
# #  def edit  
# #  end
# #  
# #  def update
# #    @fee = Message.find(params[:id])
# #    
# #    
# # 
# #  @fee.each do |fee| 
# #    if fee.untrash(current_user)
# #      flash[:success] = :recycled_fee.l
# #    else
# #      # This should never happen...
# #      flash[:error] = :invalid_action.l
# #    end
# #  end
# #  respond_to do |format|
# #    format.html { 
# #      redirect_to fees_url }
# #    end
# # 
# #  
# #    
# #    
# #    @user = User.find(params[:user][:id])
# #    @group = Group.find(params[:group][:id])   
# #    @fee.debit_user_id = @user.id
# #    @fee.credit_group_id = @group.id
# #    @fee.credit_amount = @fee.debit_amount
# #    @fee.debit_amount = @fee.debit_amount * -1       
# #    if @fee.save
# #      redirect_to :action => 'index'
# #    else
# #      render :action => 'user_fee'
# #    end    
# #  end 
# #  
# #  def new_team_fee
# #    @fee = Fee.new
# #    @user = User.find(params[:id])
# #    @group = Group.find(:first, :conditions => ["id = 1"])
# #  end
# #  
# #  def team_fee
# #    @fee = Fee.new(params[:fee])
# #    @user = User.find(params[:user][:id])
# #    @group = Group.find(params[:group][:id])   
# #    @fee.debit_group_id = @group.id
# #    @fee.credit_user_id = @user.id
# #    @fee.credit_amount = @fee.debit_amount
# #    @fee.debit_amount = @fee.debit_amount * -1       
# #    if @fee.save
# #      redirect_to :action => 'index'
# #    else
# #      render :action => 'team_fee'
# #    end    
# #  end  
# #  
# #  def new_location_fee
# #    @fee = Fee.new
# #    @location = Location.find(params[:id])
# #    @group = Group.find(:first, :conditions => ["id = 1"])
# #  end
# #  
# #  def location_fee
# #    @fee = Fee.new(params[:fee])
# #    @location = Location.find(params[:location][:id])
# #    @group = Group.find(params[:group][:id])   
# #    @fee.debit_group_id = @group.id
# #    @fee.credit_location_id = @location.id
# #    @fee.credit_amount = @fee.debit_amount
# #    @fee.debit_amount = @fee.debit_amount * -1       
# #    if @fee.save
# #      redirect_to :action => 'index'
# #    else
# #      render :action => 'location_fee'
# #    end    
# #  end  
# #   
# # end
