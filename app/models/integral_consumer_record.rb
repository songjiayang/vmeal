#encoding = utf-8
class IntegralConsumerRecord < ActiveRecord::Base
  validates :address, :phone, :name,:presence => true
  validates :phone, :numericality =>{:only_integer => true , :message =>"电话号码必须全部是数字"},
                    :length =>{ :minimum  => 7,:maximum  => 11,:message =>"电话号码必须是7-11位的数字"}
end
