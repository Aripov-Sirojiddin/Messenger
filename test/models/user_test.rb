require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
  end

  test "should be valid" do
    @user.password, @user.password_confirmation = "password", "password"
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email validation should accept valid addresses" do
    @user.password, @user.password_confirmation = "password", "password"
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email down_cased after saving to db" do
    email_address = "ExAmpLE@ExampLE.CoM"
    @user.email = email_address
    @user.save
    assert_equal email_address.downcase, @user.reload.email
  end

  test "password should be present non-blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end

  test "username should be present non-blank" do
    @user.username = ""
    assert_not @user.valid?

    @user.username = nil
    assert_not @user.valid?
  end

  test "username does not exceed 50 chars" do
    @user.username = " " * 51
    assert_not @user.valid?
  end

  test "username must be unique" do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = "other.user@example.com"
    assert_not duplicate_user.valid?
  end

  test "username cannot contain spaces" do
    @user.username = "bad example"
    assert_not @user.valid?
  end

  test "bio should be 200 characters at most" do
    @user.bio = "a" * 201
    assert_not @user.valid?
  end

  test "should follow and unfollow a user" do
    chad = users(:chad)
    mihail = users(:michael)
    assert_not mihail.following?(chad)
    mihail.follow(chad)
    assert mihail.following?(chad)
    assert chad.followers.include?(mihail)
    mihail.unfollow(chad)
    assert_not mihail.following?(chad)
    assert_not chad.followers.include?(mihail)

    mihail.follow(mihail)
    assert_not mihail.following?(mihail)
  end
end
