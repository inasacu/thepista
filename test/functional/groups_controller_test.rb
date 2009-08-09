require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Groupfirst
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Groupany_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Groupany_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to groups_url(assigns(:groups))
  end
  
  def test_edit
    get :edit, :id => Groupfirst
    assert_template 'edit'
  end
  
  def test_update_invalid
    Groupany_instance.stubs(:valid?).returns(false)
    put :update, :id => Groupfirst
    assert_template 'edit'
  end
  
  def test_update_valid
    Groupany_instance.stubs(:valid?).returns(true)
    put :update, :id => Groupfirst
    assert_redirected_to groups_url(assigns(:groups))
  end
  
  def test_destroy
    groups = Groupfirst
    delete :destroy, :id => groups
    assert_redirected_to groups_url
    assert !Groups.exists?(groups.id)
  end
end
