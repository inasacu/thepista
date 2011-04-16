require 'test_helper'

class VenuesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Venues.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Venues.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Venues.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to venues_url(assigns(:venues))
  end
  
  def test_edit
    get :edit, :id => Venues.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Venues.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Venues.first
    assert_template 'edit'
  end

  def test_update_valid
    Venues.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Venues.first
    assert_redirected_to venues_url(assigns(:venues))
  end
  
  def test_destroy
    venues = Venues.first
    delete :destroy, :id => venues
    assert_redirected_to venues_url
    assert !Venues.exists?(venues.id)
  end
end
