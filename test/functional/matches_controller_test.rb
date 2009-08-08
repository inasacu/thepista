require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Matches.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Matches.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Matches.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to matches_url(assigns(:matches))
  end
  
  def test_edit
    get :edit, :id => Matches.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Matches.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Matches.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Matches.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Matches.first
    assert_redirected_to matches_url(assigns(:matches))
  end
  
  def test_destroy
    matches = Matches.first
    delete :destroy, :id => matches
    assert_redirected_to matches_url
    assert !Matches.exists?(matches.id)
  end
end
