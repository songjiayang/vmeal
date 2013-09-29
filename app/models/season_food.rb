# encoding: utf-8
class SeasonFood < ActiveRecord::Base

  validates :introduction,:title,  :presence =>{:message =>"此内容不能为空"}

  has_attached_file :image_url,
     :styles => {
       :thumb=> "100x100#",
       :small  => "400x400>",
       :nomal  => "200x200>"}
  def self.miss_image
    HomeYaml.getYaml("config/miss_image.yml")["miss_image_url"]["season_food_image"]
  end

  def self.the_new_food
    SeasonFood.order("created_at DESC").first
  end

  def get_image_url
    if image_url.exists?
      return image_url.url(:nomal)
    else
      return Food.miss_image
    end
  end

end
