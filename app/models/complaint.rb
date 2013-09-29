#encoding:utf-8

class Complaint < ActiveRecord::Base
  
  COMPLAINT_TARGET = ["店家","送餐员","菜品质量","平台故障"]
  belongs_to :user
  has_one :complaint_reply , :dependent => :destroy
end
