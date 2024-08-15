require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @other_user = users(:chad)
  end

  test "should redirect user to log-in on edit" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect user to log-in on update" do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "user shouldn't be able to edit another users profile on edit" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "user shouldn't be able to edit another users profile on update" do
    log_in_as(@user)
    patch user_path(@other_user), params: { user: { name: "Beta", } }
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "email@not_valid",
        username: "username",
        bio: "",
        password: "password",
        password_confirmation: "password"
      }
    }
    assert_not flash.empty?
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Testing name change"
    email = "email@valid.com"
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        username: "username",
        bio: "",
        password: "password",
        password_confirmation: "password"
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
end
