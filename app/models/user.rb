class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:   "Relationship",
                                  foreign_key:  "follower_id",
                                  dependent:    :destroy

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                    dependent:  :destroy

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relstiondhips, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive:false }
  has_secure_password
  validates :password, presence: true, length: { minimum:6 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_bsase64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(rember_token))
  end

  def authenticated?(remember_token)
    digest = send("#{attribute}_digest")
    return false if remember_digest.nil?
    Bcrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated:   , activated_at: )
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れてりる場合はture  を返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    #メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    #有効化トークンとダイジェストを作成および代入する
　　def create_activation_digest
　　  self.activation_token   = User.new_token
　　  self.activation_digest = User.digest(activation_token)
　　end

　　def feed
　　  Micropost.where("user_id = ?" , id)
　　end

　　# ユーザーをフォローする
　　def follow(other_user)
　　  following << other_user
　　end

　　# ユーザーをフォロー解除する
　　def unfollow(other_user)
　　  active_relationships.find_by(followed_id: other_user.id).destroy
　　end

　　# 現在のユーザーがフォローしてたらtrueを返す
　　def following?(other_user)
　　  following.include?(other_user)
　　end

　　private
end
