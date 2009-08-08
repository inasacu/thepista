require 'test_helper'

class TeammatesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Teammates.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Teammates.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Teammates.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to teammates_url(assigns(:teammates))
  end
  
  def test_edit
    get :edit, :id => Teammates.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Teammates.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Teammates.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Teammates.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Teammates.first
    assert_redirected_to teammates_url(assigns(:teammates))
  end
  
  def test_destroy
    teammates = Teammates.first
    delete :destroy, :id => teammates
    assert_redirected_to teammates_url
    assert !Teammates.exists?(teammates.id)
  end
end
