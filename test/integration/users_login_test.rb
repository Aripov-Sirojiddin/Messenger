require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end
  test "login with invalid informations" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } }
    assert_template "sessions/new"
    assert_not is_logged_in?
    assert_not flash.empty?
    get root_path
  end

  test "login with valid informations" do
    get login_path
    post login_path, params: { session: { email: "example@example.com",
                                          password: 'example' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "button", count: 2
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "example@example.com",
                                          password: "invalid" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
  end
end
