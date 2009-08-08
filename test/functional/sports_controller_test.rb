require 'test_helper'

class SportsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Sports.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Sports.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Sports.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to sports_url(assigns(:sports))
  end
  
  def test_edit
    get :edit, :id => Sports.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Sports.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Sports.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Sports.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Sports.first
    assert_redirected_to sports_url(assigns(:sports))
  end
  
  def test_destroy
    sports = Sports.first
    delete :destroy, :id => sports
    assert_redirected_to sports_url
    assert !Sports.exists?(sports.id)
  end
end
