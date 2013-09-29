class StoCategory < ActiveRecord::Base
  
   def find_all_stores
      Store.find_by_categore name,:limit =>100
   end
   
   def self.find_all_story_category
         a=[]
         StoCategory.all.each do |category|
           a<<category.name
         end
         a
   end
  
end
