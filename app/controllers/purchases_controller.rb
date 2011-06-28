require "base64"

class PurchasesController < ApplicationController
  before_filter :require_user
  before_filter :the_maximo  if production?
  

  include SslRequirement
  ssl_required :index, :credit

  before_filter   :load_card

  filter_parameter_logging :creditcard

  BILL_PAYMENT = 0
  INSTALLATION_ID = 0
  BLOCK_TOKEN = "XXX"

  def self.set(bill_payment, installation_id, block_token)
    const_set("BILL_PAYMENT", bill_payment)
    const_set("INSTALLATION_ID", installation_id)
    const_set("BLOCK_TOKEN", block_token)
  end
  
  def index

    if params[:id]
      @installation = Installation.find(params[:id])
      @block_token = params[:block_token]
      # @installation.starts_at = Base64::decode64(@block_token.to_s).to_i
      PurchasesController.set((@installation.fee_per_game * 100).to_i + (@installation.fee_per_lighting * 100).to_i, @installation.id, @block_token)


      @reservation = Reservation.new    
      @reservation.concept = "#{current_user.name}"   
      @reservation.starts_at = Time.zone.at(Base64::decode64(@block_token.to_s).to_i)
      @reservation.ends_at = @reservation.starts_at + (@installation.timeframe).hour  
      @reservation.block_token = Base64::b64encode(@reservation.starts_at.to_i.to_s)   

      # verify reservation has not already been made
      @reservation_available = Reservation.reservation_available(@venue, @installation, @reservation)
      @pre_purchase_available = PrePurchase.pre_purchase_available(@installation, @reservation.block_token, current_user)

      unless @reservation_available      
        flash[:notice] = I18n.t(:reservations_unavailable)
        redirect_to :action => 'index', :id => @installation
        return
      end    

      # if @installation
      #   @reservation.installation_id = @installation.id
      #   @reservation.venue_id = @venue.id
      # 
      #   @reservation.fee_per_game = @installation.fee_per_game
      #   @reservation.fee_per_lighting = @installation.fee_per_lighting
      # end

      @pre_purchase = PrePurchase.new
      @pre_purchase.installation_id = @installation.id
      @pre_purchase.block_token = @reservation.block_token
      @pre_purchase.item = current_user

      if @pre_purchase_available
        unless @pre_purchase.save 
          redirect_to root_url
          return
        end
      end
    end
    
  end

  def new
  end

  # Use the DirectPayment API
  def credit
    render :action => 'index' and return unless @creditcard.valid?

    @response = paypal_gateway.purchase(BILL_PAYMENT, @creditcard, :ip => request.remote_ip)

    if @response.success?
      @purchase = Purchase.create(:response => @response)
      redirect_to :action => "complete", :id => @purchase
    else
      paypal_error(@response)
    end
  end

  # Use the Express Checkout API
  def express
    gateway = paypal_gateway(:paypal_express)
    
    # if params[:id]
    #   @installation = Installation.find(params[:id])
    #   @block_token = params[:block_token]
    #   @installation.starts_at = Base64::decode64(@block_token.to_s).to_i
    #   PurchasesController.set((@installation.fee_per_game * 100).to_i + (@installation.fee_per_lighting * 100).to_i, @installation.id, @block_token)
    # end

    @response = gateway.setup_purchase(BILL_PAYMENT, :return_url => url_for(:action => 'express_complete'), 
    :cancel_return_url => url_for(:action => 'index'),
    :description => "My Great Product Name")

    if @response.success?
      # The useraction=commit in the redirect URL tells PayPal there won't
      # be an additional review step at our site before a charge is made
      redirect_to "#{gateway.redirect_url_for(@response.params['token'])}&useraction=commit"
    else
      paypal_error(@response)
    end
  end

  # PayPal Express redirects from PayPal back to this action with a token
  def express_complete
    gateway = paypal_gateway(:paypal_express)
    @details = gateway.details_for(params[:token])

    if @details.success?
      @response = gateway.purchase(BILL_PAYMENT, :token => @details.params['token'], :payer_id => @details.params['payer_id'])

      if @response.success?
        @purchase = Purchase.create(:response => @response)
        redirect_to :action => "complete", :id => @purchase
      else
        paypal_error(@response)
      end

    else
      paypal_error(@details)
    end
  end

  def complete
    unless @purchase = Purchase.find_by_token(params[:id])
      raise ActiveRecord::RecordNotFound 
    end
    
    # @installation = Installation.find(INSTALLATION_ID)
    
    
  end

  protected

  def paypal_gateway(gw = :paypal)
    ActiveMerchant::Billing::Base.gateway(gw).new(YAML.load_file(File.join(RAILS_ROOT, 'config', 'paypal.yml'))[RAILS_ENV].symbolize_keys)
  end

  def paypal_error(response)
    @paypal_error = response.message
    render :action => 'index'
  end

  def load_card
    @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
  end

  # def get_installation
  #   @installation = Installation.find(params[:id])
  #   @venue = @installation.venue
  # end

  
  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end
end
