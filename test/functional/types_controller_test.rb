require 'test_helper'

class TypesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Types.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Types.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Types.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to types_url(assigns(:types))
  end
  
  def test_edit
    get :edit, :id => Types.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Types.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Types.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Types.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Types.first
    assert_redirected_to types_url(assigns(:types))
  end
  
  def test_destroy
    types = Types.first
    delete :destroy, :id => types
    assert_redirected_to types_url
    assert !Types.exists?(types.id)
  end
end
