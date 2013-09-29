#encoding: utf-8
class OrderPeriod < ActiveRecord::Base
  has_one :peak_order_period, :dependent => :destroy
  accepts_nested_attributes_for :peak_order_period, allow_destroy: true
  SELECT_TYPE=["早餐","午餐","晚餐","夜宵","一般时段"]

  MAX_NUMBERS=[20,30,40,50,60,70,100,120,140,200,10000]


  def self.time_selector
    times = []
    (8..22).each do |hour|
      ["00","15","30","45"].each do |min|
        times << (hour.to_s+":"+min)
      end
    end
    times
  end
end
