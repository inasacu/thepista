require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Groups.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Groups.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Groups.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to groups_url(assigns(:groups))
  end
  
  def test_edit
    get :edit, :id => Groups.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Groups.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Groups.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Groups.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Groups.first
    assert_redirected_to groups_url(assigns(:groups))
  end
  
  def test_destroy
    groups = Groups.first
    delete :destroy, :id => groups
    assert_redirected_to groups_url
    assert !Groups.exists?(groups.id)
  end
end
