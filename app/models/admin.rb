#encoding:utf-8

class Admin < ActiveRecord::Base

  attr_accessible :name, :role, :password, :password_confirmation

  has_secure_password

  VALID_INPUT_REGEX = /[\w|!|@|#|$]+/i
  validates :name, presence: true,length: { maximum: 20 , minimum: 6 },format: { with: VALID_INPUT_REGEX },uniqueness: true
  validates :password, presence: true, length: { minimum: 6 ,maximum: 30},format: { with: VALID_INPUT_REGEX }
  validates :password_confirmation, presence: true
  validates :role, presence: true ,:inclusion => { :in => [1,2]}

  ADMIN_TYPE = ["超级管理员","客服人员"]

  def index_top_data
    data = []
    data << User.numbers
    data << User.where("created_at > ?",1.weeks.ago).size
    data << Order.where("Date(created_at) = ?",1.days.ago.to_date).size
    data << Order.where("Date(created_at) = ?",Time.now.to_date).size
    data << 40
    data << 10
    data << 25
    data <<12
  end

end