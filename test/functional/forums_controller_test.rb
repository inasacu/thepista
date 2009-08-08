require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Forums.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Forums.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Forums.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to forums_url(assigns(:forums))
  end
  
  def test_edit
    get :edit, :id => Forums.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Forums.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Forums.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Forums.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Forums.first
    assert_redirected_to forums_url(assigns(:forums))
  end
  
  def test_destroy
    forums = Forums.first
    delete :destroy, :id => forums
    assert_redirected_to forums_url
    assert !Forums.exists?(forums.id)
  end
end
