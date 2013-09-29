# encoding: utf-8

class SendAddress < ActiveRecord::Base
  
  
  belongs_to :user
  validates :tel_number1, :numericality =>{:only_integer => true , :message =>"电话号码必须全部是数字"},
                    :length =>{ :minimum  => 7,:maximum  => 11,:message =>"电话号码必须是7-11位的数字"}
         
              
  def self.is_a_phone_number?(phone_number)
    str = /^[0-9]{11}+$/
    str.match(phone_number).nil?
  end 
end
