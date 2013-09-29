#encoding:utf-8
class Order < ActiveRecord::Base

  @@has_new = 0
  PAYMENT_TYPES =['货到付款']
  ORDER_STATUS = ['下单成功','申请弃单中','弃单','交易成功','订单被取消']

  TIME_NOW_BEGIN = (Time.now.min < 20)?  (Time.now.beginning_of_hour + 45.minutes).strftime("%H:%M").split(",") : []

  SEND_TIME = ['立即送出'] + TIME_NOW_BEGIN + ((Time.now.beginning_of_hour + 1.hour).to_i..3.hour.from_now.end_of_hour.to_i).to_a.in_groups_of(30.minutes).collect(&:first).collect { |t| Time.at(t).strftime("%H:%M") }

  ORDER_STATUS_HASH = {0 => "下单成功",1 => "申请弃单中",2 => "弃单" ,3 => "交易成功",4 => "订单被取消",5 => "店家正在烹饪"}

  validates :address, :phone, :name, :send_time, :presence => true
  validates :address ,:length =>{ :maximum => 30,:message =>"店家名称不能超过了30个字符"}
  validates :phone, :numericality =>{:only_integer => true , :message =>"电话号码必须全部是数字"},
  :length =>{ :minimum  => 7,:maximum  => 11,:message =>"电话号码必须是7-11位的数字"}

  #validates :pay_type, :inclusion => PAYMENT_TYPES
  validates :send_time, :inclusion => SEND_TIME

  has_many :line_items ,:dependent => :destroy

  belongs_to :user
  belongs_to :food_senter
  belongs_to :store

  after_create :fresh_hot_foods_and_store

  def self.auto_complete_with_phone_store
    Order.where("updated_at > ?",Time.now.at_midnight).select{|order| order.store.isphone == 1}.each{|order| order.update_attributes(:order_status => 3)}
  end

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    line_items.map { |e| e.total_price }.sum
  end

  def total_foods
    line_items.map { |line_item| line_item.quantity }.sum
  end

  def self.has_new?
    if @@has_new > 0
      return true
    else
      return false
    end
  end

  def self.has_new
    @@has_new += 1
  end

  def self.clear_status
    @@has_new = 0
  end

  def total_stores
    stores_id = []
    line_items.each do |item|
      if !stores_id.include?item.food.category.store_id
        stores_id << item.food.category.store_id
      end
    end
    return stores_id.length
  end

  def self.find_new_orders
    orders_line_items =[]
    orders = Order.order("created_at DESC").limit(10).all
    orders.each do |order|
      order.line_items.each do |line_item|
        h ={}
        h['user_name']= User.find_by_id(order.user_id).username
        h['line_item'] = line_item
        orders_line_items<<h
        if orders_line_items.length ==10
          return orders_line_items
        end
      end
    end
    orders_line_items
  end

  def count_foods_number
    line_items.each do |line_item|
      food = line_item.food
      food.sales_count += line_item.quantity
      food.save
    end
  end

  def translate_status_to_s
    case order_status
    when 0 then "下单成功"
    when 1 then "申请弃单中"
    when 2 then "弃单"
    when 3 then "交易成功"
    when 4 then "取消订单"
    else "下单成功"
    end
  end

  def self.translate_status_to_i(status)
    case status
    when  "下单成功" then 0
    when  "申请弃单中" then 1
    when  "弃单" then 2
    when  "交易成功" then 3
    when  "取消订单" then 4
    else 0
    end
  end

  def modify_status
    case order_status
    when 0 then 1
    when 1 then 2
    when 2 then 3
    when 3 then 4
    when 4 then 4
    when 5 then 5
    else 0
    end
  end

  def in_five_minutes?
    created_at  > Time.now -  5.minutes
  end

  def self.search(start_time,end_time, status)
    Order.where("created_at >= ? and created_at <= ? and order_status=?", start_time,end_time,status)
  end

  def can_commnet?
    Order.translate_status_to_i("交易成功")== order_status
  end

  def my_complaint
    Complaint.where("order_number=? and (target = '店家' or target = '菜品质量')",order_number).first
  end

  def self.find_order_by_number(number)
    Order.where("order_number = ? ",number).first
  end

  def self.all_orders_with_store_id(type=1,store_id)
    if type ==1
      return Order.where("order_status >2 and store_id = ?",store_id).order("created_at DESC")
    else
      return Order.where("order_status <3 and store_id = ?",store_id).order("created_at DESC")
    end
  end

  def self.find_with_a_time_limit(start_time,end_time,user_id,status = [4,5])
    Order.where(:created_at => start_time..end_time,:user_id=>user_id,:order_status=>status)
  end

  def self.shuffle_order_number
    [*?0..?9].sample(6).join
  end

  def self.orders_with_id_and_date(store_id,date)
    Order.where("store_id = ? and DATE(updated_at) = DATE(?)" , store_id , date)
  end

  #店家order的total_price
  def self.store_total_order_price(orders)
    orders.map { |order| order.total_price }.sum
  end

  def self.create_with_a_cart(cart_id,user_info)
    carts = Cart.find_my_cart(cart_id)
    order_ids = []
    carts.each do |k,v|
      order_info = {:order_number=>Time.now.to_s(:number)+shuffle_order_number,:store_id=>k.to_i}
      order = Order.create(user_info.merge(order_info))
      order_ids << order.id
      v["line_items"].each do |k,v|
        line_item = {:food_id=>k.to_i,
          :order_id => order.id,
          :quantity =>v["count"]
        }
        LineItem.create(line_item)
      end
      order_comment = order.comment.to_s == ""? "" : (",备注:" + order.comment)
      if Rails.env.production?
        if order.store.isphone == 1
          food_info = order.line_items.map { |e|"#{e.food.name}#{e.quantity}份"}
          message = "订餐信息:订单编号:#{order.order_number.last(6)};"+food_info.join(";")+"总价#{order.total_price}元.(送餐地址:#{order.address},用户姓名:#{order.name},电话:#{order.phone} #{order_comment})"
          MobileShortMessage.send_message(order.store.tel,message.to_s)
          ShortPhone.create({content:message, phone_number:order.store.tel, store_id:order.store.id})
          #店家跟用户都发送信息
          message_user = "尊敬的用户您好:您在【微大学】预订的订单编号:#{order.order_number.last(6)}（" + food_info.join(";") + "）店家【#{order.store.name}】已经收到。店家会在最短时间内给您烹饪、配送。如有任何疑问请致电【#{order.store.name}】：#{order.store.tel}。感谢您对【微大学】的支持，祝您用餐愉快。【http://weidaxue.me/】"
          MobileShortMessage.send_message(order.phone,message_user.to_s)
          ShortPhone.create({content:message_user, phone_number:order.phone, store_id:order.store.id})
        elsif order.store.isphone == 0
          food_info = order.line_items.map { |e|"#{e.food.name}#{e.quantity}份"}
          message = "【微大学】温馨提示：【#{order.store.name}】您好，您有编号为#{order.order_number.last(6)}新的订单，请尽快到店家后台查看、配送。【微大学感谢您的支持】"
          MobileShortMessage.send_message(order.store.tel,message.to_s)
          ShortPhone.create({content:message, phone_number:order.store.tel, store_id:order.store.id})
          #店家跟用户都发送信息
          message_user = "尊敬的用户您好:您在【微大学】预订的订单编号:#{order.order_number.last(6)}（" + food_info.join(";") + "）店家【#{order.store.name}】已经收到。店家会在最短时间内给您烹饪、配送。如有任何疑问请致电【#{order.store.name}】：#{order.store.tel}。感谢您对【微大学】的支持，祝您用餐愉快。【http://weidaxue.me/】"
          MobileShortMessage.send_message(order.phone,message_user.to_s)
          ShortPhone.create({content:message_user, phone_number:order.phone, store_id:order.store.id})
        end
      end
    end
    Cart.delete_my_cart(cart_id)==1
    order_ids
  end

  private

  def fresh_hot_foods_and_store
    School.all.each do |school|
      $redis.del("hot_foods_of_#{school.name}")
      $redis.del("stores_of_#{school.name}")
    end
  end
end
