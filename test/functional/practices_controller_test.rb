require 'test_helper'

class PracticesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:practices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create practices" do
    assert_difference('Practices.count') do
      post :create, :practices => { }
    end

    assert_redirected_to practices_path(assigns(:practices))
  end

  test "should show practices" do
    get :show, :id => practices(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => practices(:one).to_param
    assert_response :success
  end

  test "should update practices" do
    put :update, :id => practices(:one).to_param, :practices => { }
    assert_redirected_to practices_path(assigns(:practices))
  end

  test "should destroy practices" do
    assert_difference('Practices.count', -1) do
      delete :destroy, :id => practices(:one).to_param
    end

    assert_redirected_to practices_path
  end
end
