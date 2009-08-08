require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Schedules.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Schedules.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Schedules.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to schedules_url(assigns(:schedules))
  end
  
  def test_edit
    get :edit, :id => Schedules.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Schedules.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Schedules.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Schedules.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Schedules.first
    assert_redirected_to schedules_url(assigns(:schedules))
  end
  
  def test_destroy
    schedules = Schedules.first
    delete :destroy, :id => schedules
    assert_redirected_to schedules_url
    assert !Schedules.exists?(schedules.id)
  end
end
