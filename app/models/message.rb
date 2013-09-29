class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  has_one :reply ,:dependent => :destroy
end
