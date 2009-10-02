require 'test_helper'

class CustomDataTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_data_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_data_type" do
    assert_difference('CustomDataType.count') do
      post :create, :custom_data_type => { }
    end

    assert_redirected_to custom_data_type_path(assigns(:custom_data_type))
  end

  test "should show custom_data_type" do
    get :show, :id => custom_data_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => custom_data_types(:one).to_param
    assert_response :success
  end

  test "should update custom_data_type" do
    put :update, :id => custom_data_types(:one).to_param, :custom_data_type => { }
    assert_redirected_to custom_data_type_path(assigns(:custom_data_type))
  end

  test "should destroy custom_data_type" do
    assert_difference('CustomDataType.count', -1) do
      delete :destroy, :id => custom_data_types(:one).to_param
    end

    assert_redirected_to custom_data_types_path
  end
end
