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
                                          password: 'password' } }
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

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "button", text: "Log out"
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  test "login with remembering" do
    log_in_as(@user)
    assert_equal assigns(:user).remember_token, cookies[:remember_token]
    assert_not_nil cookies[:remember_token]
  end

  test "login without remembering" do
    log_in_as(@user)
    log_in_as(@user, remember_me: '0')
    assert_equal cookies[:remember_token], ""
  end
end
