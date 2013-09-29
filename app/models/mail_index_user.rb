#encoding = utf-8
class MailIndexUser < ActiveRecord::Base
  attr_accessible :mail_id, :read_status, :receive_status, :receiver_user_id, :send_status, :send_user_id
  belongs_to :user
end
