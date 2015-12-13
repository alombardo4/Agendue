require 'test_helper'

class PremiumUsersControllerTest < ActionController::TestCase
  setup do
    @premium_user = premium_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:premium_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create premium_user" do
    assert_difference('PremiumUser.count') do
      post :create, premium_user: { admin_init: @premium_user.admin_init, name: @premium_user.name }
    end

    assert_redirected_to premium_user_path(assigns(:premium_user))
  end

  test "should show premium_user" do
    get :show, id: @premium_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @premium_user
    assert_response :success
  end

  test "should update premium_user" do
    patch :update, id: @premium_user, premium_user: { admin_init: @premium_user.admin_init, name: @premium_user.name }
    assert_redirected_to premium_user_path(assigns(:premium_user))
  end

  test "should destroy premium_user" do
    assert_difference('PremiumUser.count', -1) do
      delete :destroy, id: @premium_user
    end

    assert_redirected_to premium_users_path
  end
end
