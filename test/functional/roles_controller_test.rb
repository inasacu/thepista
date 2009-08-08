require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Roles.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Roles.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Roles.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to roles_url(assigns(:roles))
  end
  
  def test_edit
    get :edit, :id => Roles.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Roles.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Roles.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Roles.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Roles.first
    assert_redirected_to roles_url(assigns(:roles))
  end
  
  def test_destroy
    roles = Roles.first
    delete :destroy, :id => roles
    assert_redirected_to roles_url
    assert !Roles.exists?(roles.id)
  end
end
