#encoding = utf-8
class MailIndexUser < ActiveRecord::Base
  belongs_to :user
end
