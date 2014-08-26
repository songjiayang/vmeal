#encoding:utf-8
require 'nokogiri'
class Vmail < ActiveRecord::Base
  validates :admin_id, :content, :sent_mails, :title, :presence => true 
  STATUS=["未发送","已发送"]

  def format_content
  	page = Nokogiri::HTML(content)
  	result = content
  	images =  page.search("img").map{|img| img.attributes["src"].value}.select{|url|url.start_with? "/"}
    puts images
  	images.each do |url|
  		 result = result.gsub(url,MY_HOST+url.to_s)
  	end
  	result
  end
end
