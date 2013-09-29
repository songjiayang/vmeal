class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  #用来保证用户收藏的店家id唯一
  validates_uniqueness_of :store_id, :scope => :user_id
end
