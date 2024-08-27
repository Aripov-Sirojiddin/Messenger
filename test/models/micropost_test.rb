require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:chad)
    # This code is not idiomatically correct.
    @micropost = @user.microposts.build(content: "What up! I am a micropost!", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "order must be most recent" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "associated microposts should be destroyed" do
    @user.save
    assert_difference "Micropost.count",-1 do
      @user.destroy
    end
  end
end
