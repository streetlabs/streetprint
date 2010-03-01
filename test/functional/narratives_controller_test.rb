require 'test_helper'

class NarrativesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:narratives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create narrative" do
    assert_difference('Narrative.count') do
      post :create, :narrative => { }
    end

    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "should show narrative" do
    get :show, :id => narratives(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => narratives(:one).to_param
    assert_response :success
  end

  test "should update narrative" do
    put :update, :id => narratives(:one).to_param, :narrative => { }
    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "should destroy narrative" do
    assert_difference('Narrative.count', -1) do
      delete :destroy, :id => narratives(:one).to_param
    end

    assert_redirected_to narratives_path
  end
end
