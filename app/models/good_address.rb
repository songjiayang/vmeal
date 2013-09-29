class GoodAddress < ActiveRecord::Base
  validates  :address, :real_name, :tel_number, :user_id, :presence => true
  belongs_to :user
end
