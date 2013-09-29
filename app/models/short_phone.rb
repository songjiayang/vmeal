class ShortPhone < ActiveRecord::Base
  attr_accessible :content, :phone_number, :store_id
  belongs_to :store
end
