#encoding = utf-8
class StationMail < ActiveRecord::Base
  attr_accessible :content, :title
  has_many :users
  has_many :mail_index_users
  #判断邮件是否发送
  def send_success?
    MailIndexUser.where(:mail_id => id).size > 0
  end
end
