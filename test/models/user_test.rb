require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", 
                     email: "test@example.com",
                     password: "hunter2",
                     password_confirmation: "hunter2")

  end

  test "password non empty" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be minimum length" do
    @user.password = @user.password_confirmation = "A" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @other = User.new(name: "Test User", 
                     email: "test@example.com",
                     password: "loremipsum",
                     password_confirmation: "loremipsum")
    @other.save

    @other.microposts.create!(content: "Lipsum")
    assert_difference 'Micropost.count', -1 do
      @other.destroy
    end
  end
end
