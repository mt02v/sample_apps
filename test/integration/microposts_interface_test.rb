require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_url
    assert_select 'div.pagination'
    assert_select 'input[type=(コードを書き込む) ] '
    # 無効の送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
      assert_select 'div#error_explanation'
    # 有効な送信
      content = "This micropost really ties the room together"
      picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
      assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: 
                                      { content: content,
                                        picture: (コードを書き込む) } }
    end
    assert (コードを書き込む) .picture?
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count',-1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{(コードを書き込む) } microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 miroposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match (コードを書き込む) , response.body
  end
end
