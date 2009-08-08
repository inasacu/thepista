require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Topics.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Topics.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Topics.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to topics_url(assigns(:topics))
  end
  
  def test_edit
    get :edit, :id => Topics.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Topics.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Topics.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Topics.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Topics.first
    assert_redirected_to topics_url(assigns(:topics))
  end
  
  def test_destroy
    topics = Topics.first
    delete :destroy, :id => topics
    assert_redirected_to topics_url
    assert !Topics.exists?(topics.id)
  end
end
