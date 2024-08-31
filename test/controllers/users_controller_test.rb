require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @non_admin = users(:example)
    @admin = users(:michael)
  end

  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@non_admin)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as wrong user non-admin" do
    log_in_as(@non_admin)
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_path
  end
  test "can delete self" do
    log_in_as(@non_admin)
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  test "admin can delete other users" do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'button', text: 'delete', count: 0
  end

  test "should redirect following when not logged in" do
    get following_user_path(@non_admin)
    assert_redirected_to login_url
  end
  test "should redirect followers when not logged in" do
    get followers_user_path(@non_admin)
    assert_redirected_to login_url
  end
end
