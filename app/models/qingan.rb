#encoding : utf-8
class Qingan < ActiveRecord::Base
  attr_accessible :name, :telephone
  validates_presence_of :name,:telephone , :message => "请填写完整信息!"
  validates_numericality_of :telephone
  validates_length_of :telephone, minimum: 11, maximum: 11
end
