require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should not allow login when logged in" do
    @user = users(:one)

    log_in_as(@user)
    get login_path
    assert_redirected_to user_path(@user)
  end

  test "should not log in when not activated" do
    @user = users(:inactive)

    log_in_as(@user)
    assert_redirected_to root_url
  end

end
