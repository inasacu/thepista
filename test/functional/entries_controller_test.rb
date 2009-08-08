require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Entries.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Entries.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Entries.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to entries_url(assigns(:entries))
  end
  
  def test_edit
    get :edit, :id => Entries.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Entries.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Entries.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Entries.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Entries.first
    assert_redirected_to entries_url(assigns(:entries))
  end
  
  def test_destroy
    entries = Entries.first
    delete :destroy, :id => entries
    assert_redirected_to entries_url
    assert !Entries.exists?(entries.id)
  end
end
