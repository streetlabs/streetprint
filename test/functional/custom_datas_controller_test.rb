require 'test_helper'

class CustomDatasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_datas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_data" do
    assert_difference('CustomData.count') do
      post :create, :custom_data => { }
    end

    assert_redirected_to custom_data_path(assigns(:custom_data))
  end

  test "should show custom_data" do
    get :show, :id => custom_datas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => custom_datas(:one).to_param
    assert_response :success
  end

  test "should update custom_data" do
    put :update, :id => custom_datas(:one).to_param, :custom_data => { }
    assert_redirected_to custom_data_path(assigns(:custom_data))
  end

  test "should destroy custom_data" do
    assert_difference('CustomData.count', -1) do
      delete :destroy, :id => custom_datas(:one).to_param
    end

    assert_redirected_to custom_datas_path
  end
end
