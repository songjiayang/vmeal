class School < ActiveRecord::Base
  has_attached_file :avatar, 
               :styles => { :thumb => "300x150>", :small => "30x15>" },
               :default_url => "/system/miss/school/miss.jpg"
end
