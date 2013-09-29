class LineItem < ActiveRecord::Base
  belongs_to :food
  belongs_to :cart
  belongs_to :order

  def total_price
    if food
      return food.price * quantity 
    end
    return 0.0
  end

  def update_comment_number_and_score
    food.comment_number += quantity
    food.comment_score += quantity*rank
    food.save
  end

  #增加用户的评论的方法
  def add_user_comment
    lineitem = LineItem.find(1)
    lineitem.save
  end
  
end
