#encoding:utf-8
class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  #include Devise::Async::Model # should be below call to `devise`
  # Setup accessible (or protected) attributes for your model
  validates :username , :length => {:in => 3..30 , :message => "用户名必须为3-30个字符"}
  has_attached_file :image_url,
     :styles => {
       :thumb=> "80x80#",
       :small  => "30x30>",
       :big  => "90x90>"}

  has_one  :store
  has_many :orders
  has_many :complaints ,:dependent => :destroy
  has_many :send_address
  #增加用户和收藏的级联关系的删除
  has_many :favorites , :dependent => :destroy
  has_many :stores, :through => :favorites
  #增加用户收藏的食品
  has_many :favorite_foods , :dependent => :destroy
  has_many :foods, :through => :favorite_foods
  has_many :messages ,:dependent => :destroy
  has_one :application , :dependent =>:destroy
  has_one :good_address, :dependent =>:destroy
  has_and_belongs_to_many :activities
  belongs_to :station_mail

  after_create :fresh_the_number

  #异步邮箱
  # handle_asynchronously :send_reset_password_instructions , :run_at => Proc.new { Time.now }
  # handle_asynchronously :send_confirmation_instructions  , :run_at => Proc.new { Time.now }
  # handle_asynchronously :send_on_create_confirmation_instructions  , :run_at => Proc.new { Time.now }
  def can_increment_sent_address?
    send_address.size<10? true:false
  end

  def self.store_hosts
    User.where(["is_store = 0"]).all
  end

  def self.locked_users
    User.where(["is_locked = 1"]).all
  end

  def all_my_favorate_id
    favorite_foods.map {|food| food.id}
  end

  #判断当前用户是否收藏了该店
  def is_constains_store?(fav_store_id)
    Favorite.where(:user_id => id).select(:store_id).all.map { |p| p.store_id }.include?(fav_store_id)
  end

  #判断当前用户是否收藏了该食品
  def is_constains_food?(fav_food_id)
    FavoriteFood.where(:user_id => id).select(:food_id).all.map { |p| p.food_id }.include?(fav_food_id)
  end

  def get_image_url(type="big")
    if image_url.exists?
      case type
      when "thumb"
        image_url.url(:thumb)
      when "small"
        image_url.url(:small)
      else
      image_url.url(:big)
      end
    else
      unless image_url_file_name.blank?
        image_url_file_name
      else
        CONFIG["user_image_miss"]
      end
    end
  end

  def all_un_complainted_orders
    array = []
    Order.where("is_complainted = 0 and user_id = ?" ,id).each do |order|
      array << order.order_number
    end
    array
  end

  def self.convert_email_to_users emails
    users = []
    emails.split(";").each do |email|
      users << User.find_by_email(email)
    end
    users
  end

  def self.numbers(refresh = false)
    User.count
  end

  def signin_number(refresh = false)
    redis_key = "users_signin_#{id}"
    if refresh || (!$redis.exists redis_key) || ($redis.get redis_key).blank?
        number = 0
        $redis.set(redis_key,number)
        number
    else
      $redis.get redis_key
    end
  end

  def signin_number=(number)
    redis_key = "users_signin_#{id}"
    $redis.set(redis_key,number)
  end

  def is_signed
    !ScoreHistories.where("user_id=? and  change_type = 1 and  DATE(created_at) = DATE('#{Time.now}')",id).blank?
  end

  def is_not_continuous
    ScoreHistories.where("user_id=? and  change_type = 1 and  DATE(created_at) = ('#{24.hour.ago.to_date}')",id).blank?
  end

  private

  def fresh_the_number
    redis_key = "users_number"
    $redis.set(redis_key,User.count)
  end

end
