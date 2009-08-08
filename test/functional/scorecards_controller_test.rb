require 'test_helper'

class ScorecardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Scorecards.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Scorecards.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Scorecards.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to scorecards_url(assigns(:scorecards))
  end
  
  def test_edit
    get :edit, :id => Scorecards.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Scorecards.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Scorecards.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Scorecards.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Scorecards.first
    assert_redirected_to scorecards_url(assigns(:scorecards))
  end
  
  def test_destroy
    scorecards = Scorecards.first
    delete :destroy, :id => scorecards
    assert_redirected_to scorecards_url
    assert !Scorecards.exists?(scorecards.id)
  end
end
