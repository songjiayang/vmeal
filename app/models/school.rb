class School < ActiveRecord::Base
  attr_accessible :name, :short_name, :avatar
  has_attached_file :avatar, 
               :styles => { :thumb => "300x150>", :small => "30x15>" },
               :default_url => "/system/miss/school/miss.jpg"
end
