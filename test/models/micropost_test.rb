require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:micheal)
    @micropost = @user.micropost.build(content: "Lorem ipsum")
  end

  test "shuld be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nill
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do
    assert_equal microposts(:post_recent), Micropost.first
  end
end