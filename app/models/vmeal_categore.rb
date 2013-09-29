#encoding:utf-8

class VmealCategore < ActiveRecord::Base


  validates :image_url,  :presence =>{:message =>"图片不能为空！"}
  
  has_attached_file :image_url,
     :styles => {
       :thumb=> "100x100#",
       :small  => "400x400>",
       :nomal  => "225x363>"}
  def self.miss_image
     HomeYaml.getYaml("config/miss_image.yml")["miss_image_url"]["vmeal_categore"]
  end

  def get_image_url
    if image_url.exists?
      return image_url.url(:nomal)
    else
      return VmealCategore.miss_image
    end
  end
  
  def self.find_category_by_name(name)
    VmealCategore.where("name=?",name).first
  end

  def foods(name,order_by)
    Food.find_by_vmeal_category_name name,order_by,:limit => 8
  end

  def self.list_every_category_high_rank_foods
    result = {}
    VmealCategore.all.each do |vmeal|
      result[vmeal.name]=vmeal.foods(vmeal.name,'sales_count DESC ')
    end
    result
  end

  def self.find_all_story_category
    a =[]
    VmealCategore.all.each do |vmeal_category|
      a << vmeal_category.name
    end
    a
  end

  def self.list_all_category_ad_foods
    result = {}
    foods = Food.find_all_by_is_ad(1,:order => 'updated_at DESC')
    VmealCategore.all.each do |vmeal|
      foods.each do |food|
        if food.vmeal_category_name == vmeal.name
        result[vmeal.name]=food
        foods.delete(food)
        end
      end
    end
    result
  end
  
  def all_ad_foods 
    Food.where(:vmeal_category_name => name,:is_ad => 1 )
  end
end
