#encoding: utf-8
class Activity < ActiveRecord::Base

  validates  :description, :end_time, :need_score, :start_time, :real_money, :title, :total_number, :presence => true , :presence =>{:message =>"不能为空"}
  has_and_belongs_to_many :users
  has_many :score_historiess, :dependent => :destroy
  has_attached_file :avatar,
     :styles => {
       :thumb=> "100x100#",
       :small  => "90x60>",
       :large  => "290x190>"},
      :default_url => '/system/miss/activity/miss.jpg'

  TYPE = ["正在进行中","即将开奖","即将开始","历史活动"]


  def status
  	now_time = Time.now
  	if start_time > now_time
  		"即将开始"
  	elsif (end_time < now_time and users.size>0)
  		 "历史活动"
  	elsif end_time < now_time
  		"即将开奖"
  	else
  		"正在进行中"
  	end	
  end
end
