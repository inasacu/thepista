require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Reservations.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Reservations.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Reservations.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to reservations_url(assigns(:reservations))
  end
  
  def test_edit
    get :edit, :id => Reservations.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Reservations.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Reservations.first
    assert_template 'edit'
  end

  def test_update_valid
    Reservations.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Reservations.first
    assert_redirected_to reservations_url(assigns(:reservations))
  end
  
  def test_destroy
    reservations = Reservations.first
    delete :destroy, :id => reservations
    assert_redirected_to reservations_url
    assert !Reservations.exists?(reservations.id)
  end
end
