require 'test_helper'

class FeesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fees" do
    assert_difference('Fees.count') do
      post :create, :fees => { }
    end

    assert_redirected_to fees_path(assigns(:fees))
  end

  test "should show fees" do
    get :show, :id => fees(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => fees(:one).to_param
    assert_response :success
  end

  test "should update fees" do
    put :update, :id => fees(:one).to_param, :fees => { }
    assert_redirected_to fees_path(assigns(:fees))
  end

  test "should destroy fees" do
    assert_difference('Fees.count', -1) do
      delete :destroy, :id => fees(:one).to_param
    end

    assert_redirected_to fees_path
  end
end
