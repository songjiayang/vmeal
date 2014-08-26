# encoding: utf-8
class Store < ActiveRecord::Base

  STORE_STATUS = ["营业","打烊"]
  STORE_STATUS_ADMIN_HASH = { 0 => "营业",  1 => "打烊" ,   2 => "退出平台"}

  STORE_TAGES = ["便宜","川菜","环保","韩式","辣的爽"]
  STORE_TYPE = {0 => "网络商家", 1 => "电话商家", 2 => "更多商家"}
  validates :isclose,  :rank, :presence => true , :presence =>{:message =>"此内容不能为空"}
  validates :name, :length =>{ :maximum => 50,:message =>"店家名称不能超过了10个字符"},
  :presence =>{:message =>"店家名称不能为空"}
  validates :isclose, :numericality =>{:only_integer => true,
    :greater_than_or_equal_to =>0,
    :less_than_or_equal_to =>2,
  }
  # attr_accessible :order_periods_attributes
  # attr_accessible :name, :order_periods_attributes
  validates :send_price, :numericality =>{:greater_than_or_equal_to =>0.01}
  validates :rank , :numericality =>{:greater_than_or_equal_to =>0,:less_than_or_equal_to =>5}
  has_many :foods ,:dependent => :destroy
  has_many :categories ,:dependent => :destroy
  has_many :favorites
  has_many :users , :through => :favorites
  has_many :messages , :dependent => :destroy
  has_many :orders , :dependent => :destroy
  has_many :order_periods, :dependent => :destroy
  accepts_nested_attributes_for :order_periods, allow_destroy: true

  belongs_to :user
  belongs_to :school
  after_save :fresh_store

  def self.find_by_categore(category_name,options = {})
    with_scope :find => options do
      find_all_by_categore(category_name, :order => 'created_at DESC')
    end
  end

  has_attached_file :image_url,
  :styles => {
    :thumb=> "100x100#",
    :small  => "76x76>",
    :nomal  => "220x150>"}

  def self.find_all_category(id)
    a =[]
    Store.find(id).categories.each do |category|
      a << category.name
    end
    a
  end

  #根据获取Store的收入
  def income_by_time(status,start_time,end_time)
    Order.where("store_id = ? and  order_status = ?  and created_at > ? and created_at < ?",id,status,start_time,end_time).map{ |order| order.total_price}.sum
  end

  def image
    image_url.exists?? image_url.url(:small):CONFIG["store_image_miss"]
  end

  #获取收藏的店家
  def self.get_fav_num(store_id)
    fav_store=Favorite.where(:store_id => store_id).select("COUNT(user_id) AS total ")
    fav_store.first.total
  end

  def self.get_store_id_by_user_id(user_id)
    Store.where(:user_id => user_id).first.id
  end

  def get_messages
    Message.where(:store_id=>id).order("id desc")
  end

  def all_comments
    LineItem.joins(:food).where("line_items.content is NOT NULL and foods.store_id =?",id).order("created_at desc")
  end

  def sold_count
    Order.where("store_id = ? and order_status = ? and created_at > ?", id, 3, Time.local(2013,03,01)).size
  end

  def all_complaints
    a=[]
    Order.where("is_complainted = 1 and store_id = ? " ,id).all.each do |order|
      a<< order.my_complaint
    end
    a
  end

  def recent_sales(start_time)
    Order.where("created_at>=? and store_id = ?",start_time,id).size
  end

  def self.new_one_default_store(user_id)
    @store = Store.new
    @store.opentime = Time.now
    @store.closetime = Time.now
    @store.isclose = 0
    @store.rank = 4
    @store.name = "test"
    @store.send_price = 10.0
    @store.image_url_file_name = "test.jpg"
    @store.user_id = user_id
    @store.save
    @store.id
  end

  def self.translate_type_i(status)
    case status
    when "打烊" then 1
    when "开业" then 0
    else 0
    end
  end

  def is_trade?
    is_shop = false
    order_periods.each do |op|
      is_shop = (isclose==0 and (Time.parse op.start_time.to_s)<Time.now and Time.now < (Time.parse op.end_time.to_s))
      break if is_shop
    end
    is_shop
  end

  def translate_type_s
    if isclose == 1
      return "假期歇业中.."
    else
      is_business_to_s
    end
  end

  def is_business
    isclose == 1? false : is_on_time
  end

  def is_business_to_s
    if is_business
      "正在营业中...."
    else
      "打烊中...."
    end
  end

  def sals_counts(time_before=nil,order_status)
    if time_before.nil?
      return   Order.where("store_id =? and order_status = ?",id,order_status).size
    else
      return  Order.where("store_id =? and created_at >=? and order_status = ?",id,time_before,order_status).size
    end

  end

  def find_category_id(name)
    categories.each do |category|
      if category.name == name
        return category.id
      end
    end
  end

  def self.find_market
    Store.where("is_super_market = 1").first
  end

  def open_time
    "#{opentime.strftime '%H:%M'}-#{closetime.strftime '%H:%M'}"
  end

  private

  def isclose_parse
    #self.isclose = STORE_STATUS_ADMIN_HASH[self.isclose]
  end

  def is_on_time
    (get_sec_of_time(opentime.to_datetime) < get_sec_of_time(Time.now)) && (get_sec_of_time(Time.now)<get_sec_of_time(closetime.to_datetime))
  end

  def get_sec_of_time(target_time)
    target_time.hour*3600+target_time.min*60+target_time.sec
  end

  def self.stores_of_a_school(school,refresh=false)
    stores =  Store.where("school_id=?",School.where(:name=>school).first.id).order("sortvalue")
  end

  def self.create_default_store
    Store.transaction do
      Store.create!(
                    :name => "微大学虚拟餐厅",
                    :introduce =>"干净好吃，快捷方便",
                    :address =>"西南石油大学",
                    :opentime => "2012-07-27  7:30:00",
                    :closetime => "2012-07-27  23:00:00",
                    :tags => "直销，免快递费",
                    :categore => "快餐、中餐、西餐",
                    :tel =>"13301631167",
                    :is_super_market =>0,
                    :isclose => 0 ,
                    :send_price => 10,
                    :rank => 4.5,
                    :settledtime => Time.now,
                    :image_url_file_name => "store.jpg",
                    :school => School.last
                    )
    end
  end

  private

  def fresh_store
    School.all.each do |school|
      Store.stores_of_a_school(school.name,true)
    end   
  end
end
