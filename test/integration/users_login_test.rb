require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end
  
  test "login without remembering" do
    #ログインを保存してログイン
    login_in_as(@user, remember_me: '1')
    delete_logout_path
    #クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is logged_in?
    assert_redirected_to root_url
    delete logout_path
    follow_ridirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count:0
    assert_select "a[href=?]", user_path(@user), count:0
  end
end
