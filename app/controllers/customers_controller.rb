class CustomersController < ApplicationController
	before_filter :require_user
  before_filter :get_customer, :only => [:edit, :update]

	def index
		@customers = Customer.page(params[:page]).order('customers.created_at DESC')
	end

	def new
		@customer = Customer.new
		@customer.city_id = 1
	end

	def create
		@customer = Customer.new(params[:customer])		
		@user = current_user
		@customer.user = @user

		if @customer.save 
			successful_create
			redirect_to :customers
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('customers/new')
	end

	def update
		if @customer.update_attributes(params[:customer]) 
			controller_successful_update
			redirect_to :customers
		else
			render :action => 'edit'
		end
	end

	

  private
  def get_customer
    @customer = Customer.find(params[:id])
  end

end
