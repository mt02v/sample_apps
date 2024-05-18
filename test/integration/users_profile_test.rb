require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  inculude ApplicationHelper
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end
  
  test "prpfile display" do
    get user_path(@user)
    assert_template "users/show"
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, reponse.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micorpos.count, response.body
    end
  end
end
