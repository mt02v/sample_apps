require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirct create when not logged in" do
    assert_no_differnce 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum"} }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_differnce 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert__redirected_to root_url
  end
end
