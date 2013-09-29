#encoding:utf-8
class FoodSenter < ActiveRecord::Base

  USER_TYPE = ["送餐员","催单员"]
  has_many :orders , :dependent => :destroy

  def get_deal_orders type
    if(type==0)
      Order.where("order_status < 4 and food_senter_id = ?",id)
    elsif (type==1)
      Order.where("order_status<2")
    end
  end

  def get_history_orders type
    if(type==0)
      Order.where("order_status >=4 and food_senter_id = ?",id).order("created_at DESC")
    elsif (type==1)
      Order.where("order_status >=2").order("created_at DESC")
    end
  end

  def  self.translate_type_i(typea)
    case typea
    when "送餐员" then 0
    when "催单员" then 1
    else 0
    end
  end

  def  translate_type_s
    case user_type
    when  0 then "送餐员"
    when  1 then "催单员"
    else "送餐员"
    end
  end

  def  translate_work_s
    case is_work
    when  0 then "休息中"
    when  1 then "工作中"
    else "休息中"
    end
  end

  def  change_status
    case is_work
    when  0 then 1
    when  1 then 0
    else 1
    end
  end

  def self.least_orders_id
    @food_senters = FoodSenter.where("user_type=0 and is_work =1").all
    index_one = @food_senters[0]
    @food_senters.each do |food_senter|
      if food_senter.all_orders.size < index_one.orders.size
      index_one = food_senter
      end
    end
    index_one.id
  end

  def all_orders
    Order.where("order_status<4 and food_senter_id =?",id)
  end
end
