class ComplaintReply < ActiveRecord::Base
   belongs_to :complaint
   belongs_to :super_man
   has_many :complaint_replies ,:dependent => :destroy
end
