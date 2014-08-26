# encoding: utf-8
class Food < ActiveRecord::Base

  #对餐品的一系列的验证
  validates :name,   :presence => true
  validates :price,  :numericality => true
  validates :sum,    :numericality => true
  validates :energy, :numericality => true
  belongs_to :store
  belongs_to :category

  #用户收藏食品
  has_many :favorites
  has_many :users , :through => :favorite_foods
  has_many :line_items

  def self.ads
      Food.where("is_ad = 1")
  end

  def self.find_by_vmeal_category_name(name,order_by,options = {})
    with_scope :find => options do
      find_all_by_vmeal_category_name(name, :order => order_by )
    end
  end

  has_attached_file :photo,
     :styles => {
       :thumb=> "180x180#"
       }


  def self.foods_name_like(name)
    Food.find(:all, :conditions=>["name like ? and store_id not in (select id from stores where isclose=2)", '%'+name.to_s+'%'])
  end

  def calculate_rank
    sum = Food.find(id).rank
    quantity = 1
    Order.where(["order_status = ?",2]).all.each do |order|
      order.line_items.each do |line_item|
        if line_item.food_id == id
        sum += line_item.rank*line_item.quantity
        quantity += line_item.quantity
        end
      end
    end
    sum.to_f/quantity
  end
 def get_food_sales_cout
     Order.where(order_status: 3).map{ |order| order.line_items}.map{|line_item| line_item.where(food_id: id).count}.sum
  end
  def get_image_url
    photo.exists?? photo.url(:thumb):CONFIG["food_image_miss"]
  end
    

  def self.find_store_categories (store_id)
    categories = []
    Category.where(:store_id => store_id).each do |food_category|
      categories << food_category.name
    end
    categories
  end

  def self.get_fav_num(food_id)
    fav_food=FavoriteFood.where(:food_id => food_id).select("COUNT(user_id) AS total ")
    fav_food.first.total
  end

  def recent_sales(start_time)
    result = 0
    LineItem.where("created_at >=? and food_id =? and order_id is not null",start_time,id).each do |line_item|
      result = result + line_item.quantity
    end
    result
  end

  def self.find_super_market_food(category_id)
    Food.where("category_id =?",category_id)
  end

  def self.get_hight_foods(number)
      Food.order("sales_count").limit(number)
  end

  def self.hot_foods(school,refresh = false)
    Food.order("sales_count DESC").select{|food| food.store.isclose < 1 and  Store.select("id").where("school_id=?",School.find_by_name(school).id).map{|s|s.id}.include? food.store_id }.first(8)
  end

end
