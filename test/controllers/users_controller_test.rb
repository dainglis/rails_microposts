require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other = users(:two)
    @admin = users(:malory) # she's the boss
  end

  test "should get index when logged in" do
    log_in_as(@user)
    get users_url
    assert_response :success
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, 
           params: { user: { name: 'Mid-Test User',
                             email: 'midtest@example.com',
                             password: 'foobarbaz',
                             password_confirmation: 'foobarbaz' } }
    end

    #assert_redirected_to user_url(User.last)
    assert_redirected_to root_url
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    log_in_as(@user)
    patch user_path(@user),
          params: { user: { name: @user.name,
                            email: @user.email,
                            password: 'password',
                            password_confirmation: 'password'  } }
    assert_redirected_to @user
  end

  test "should destroy user" do
    log_in_as(@admin)
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other)
    get edit_user_path(@user)
    #assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other)
    patch user_path(@user),
          params: { user: { name: @user.name,
                            email: @user.email } }
    #assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow setting admin priviledge" do
    log_in_as(@user)
    assert_not @user.admin?

    patch user_path(@user),
          params: { user: { admin: true } }
    assert_not @user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should not allow signup if logged in" do
    log_in_as(@user)
    get signup_path
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end

