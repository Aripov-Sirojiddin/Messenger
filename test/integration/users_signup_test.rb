require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid user creation" do
    get users_sign_up_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Valid user",
          email: "valid-3949449@email.com",
          username: "valid_username",
          bio: "",
          password: "valid_password",
          password_confirmation: "valid_password",
        }
      }
    end
    follow_redirect!
    assert flash[:info]
    assert_not flash[:danger]
  end
  test "taken email" do
    get users_sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "jitewaboh@lagify.com",
          username: "available_username",
          bio: "",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.alert-danger'
    assert_select 'div#error_explanation'
    assert flash[:danger]
  end

  test "passwords don't match" do
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "avaialeble_email_38558585932q@email.com",
          username: "available_username",
          bio: "",
          password: "password",
          password_confirmation: "doesn't match"
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.alert-danger'
    assert_select 'div#error_explanation'
    assert flash[:danger]
  end

  test "username taken" do
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "jitewaboh@lagify.com",
          username: "example_account",
          bio: "",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.alert-danger'
    assert_select 'div#error_explanation'
    assert flash[:danger]
  end
end
