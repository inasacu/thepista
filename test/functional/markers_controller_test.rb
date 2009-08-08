require 'test_helper'

class MarkersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Markers.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Markers.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Markers.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to markers_url(assigns(:markers))
  end
  
  def test_edit
    get :edit, :id => Markers.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Markers.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Markers.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Markers.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Markers.first
    assert_redirected_to markers_url(assigns(:markers))
  end
  
  def test_destroy
    markers = Markers.first
    delete :destroy, :id => markers
    assert_redirected_to markers_url
    assert !Markers.exists?(markers.id)
  end
end
