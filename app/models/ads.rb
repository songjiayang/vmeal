#encoding: utf-8

class Ads < ActiveRecord::Base
  validates :img_path, :title, :presence => true
  validates :img_path, :link_to, :length => { :maximum => 1024}
  validates :title, :length => {:maximum => 30}
  after_save :flush_ads
  belongs_to :store
  belongs_to :school

  after_save :fresh_ads

  STATUS = ["使用中","已下架"]

  TYPE = ["焦点图","一般图片"]

  ORDER_NUMBER = [1,2,3,4]


  def flush_ads(school="swpu")
  	["ads_of_#{school}_with_1","ads_of_#{school}_with_2"].each do |key|
  		$redis.del(key)
  	end
  end

  def self.all_ads(school,type)
    ads_key = "ads_of_#{school}_with_#{type.to_s}"
    if (!$redis.exists ads_key) || (JSON.parse $redis.get ads_key).blank?
    	ad_numebrs = 3
    	ad_numebrs = 4  if type == 1
      ads = Ads.where(:ad_type=>type,:status=>"使用中",:school_id=>School.find_by_name(school.to_s).id).limit(ad_numebrs).order("created_at desc")
      $redis.set(ads_key,ads.to_json ) 
      ads
    else
      ads = JSON.parse $redis.get ads_key
      ads.map { |e| 
          ad = Ads.new(e)
          ad.id = e['id']
          ad
       }
    end
  end

  private 
  def fresh_ads
    School.all.each do |school|
      $redis.del("ads_of_#{school.name}_with_1")
      $redis.del("ads_of_#{school.name}_with_2")
    end
  end
  
end
