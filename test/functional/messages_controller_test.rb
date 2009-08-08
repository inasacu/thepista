require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Messages.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Messages.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Messages.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to messages_url(assigns(:messages))
  end
  
  def test_edit
    get :edit, :id => Messages.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Messages.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Messages.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Messages.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Messages.first
    assert_redirected_to messages_url(assigns(:messages))
  end
  
  def test_destroy
    messages = Messages.first
    delete :destroy, :id => messages
    assert_redirected_to messages_url
    assert !Messages.exists?(messages.id)
  end
end
