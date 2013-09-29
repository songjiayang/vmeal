# encoding: utf-8
class Category < ActiveRecord::Base
  
  attr_accessible :name, :store
  belongs_to :store
  has_many :foods  , :dependent => :destroy
  
  def self.find_category_id(store_id,category_name)
     Category.where(["store_id = ? and name=?", store_id,category_name]).first.id
  end

  def self.get_category_id_by_name(store_id,category_name)
    Category.where(:name => category_name,:store_id => store_id ).first.id
  end
  
  def self.distinct_food_categories
     a = []
     Category.find_by_sql("select distinct name  from categories").each do |category|
       a << category.name
     end
     a 
  end

end
