require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
end

class FollowPagesTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end
  test "following page" do
    get following_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body

    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end

class UnfollowTest < Unfollow
  def setup
    @user = users(:michael)
    @other = users(:archer)
    @user.follow(@other)
    @relationship = @user.active_relationships.find_by(followed_id: @other.id)
  end
  test "should unfollow a user the standard way" do
    assert_difference "@user.following.count", -1 do
      delete relationship_path(@relationship)
    end
    assert_response :see_other
    assert_redirected_to @other
  end

  test "should unfollow a user with Hotwire" do
    assert_difference "@user.following.count", -1 do
      delete relationship_path(@relationship, format: :turbo_stream)
    end
  end
end