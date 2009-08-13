require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payments" do
    assert_difference('Payments.count') do
      post :create, :payments => { }
    end

    assert_redirected_to payments_path(assigns(:payments))
  end

  test "should show payments" do
    get :show, :id => payments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => payments(:one).to_param
    assert_response :success
  end

  test "should update payments" do
    put :update, :id => payments(:one).to_param, :payments => { }
    assert_redirected_to payments_path(assigns(:payments))
  end

  test "should destroy payments" do
    assert_difference('Payments.count', -1) do
      delete :destroy, :id => payments(:one).to_param
    end

    assert_redirected_to payments_path
  end
end
