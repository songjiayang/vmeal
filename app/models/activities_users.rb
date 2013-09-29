#encoding:utf-8
class ActivitiesUsers < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  def parse_create_time_to_cn
  	total_second = (Time.now - created_at).to_i
  	if total_second < 60
  		"大约#{total_second}秒以前"
  	elsif total_second<3600
  		"大约#{total_second/60}分钟以前"
  	elsif total_second < 86400
  		"大约#{total_second/3600}小时以前"
  	elsif total_second < 2592000
      "大约#{total_second/86400}天以前"
    elsif total_second < 31536000
    	"大约#{total_second/2592000}月以前"
    else
    	"大约#{total_second/31536000}年以前"
  	end
  end
end
