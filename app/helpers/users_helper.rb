#encoding: utf-8
module UsersHelper
  
  def do_save_comments(value)
    value["line_item"].each do |k,v|
      @line_item = LineItem.find(v["line_item_id"])
      @line_item.rank = v["score"].to_i
      @line_item.content = v["content"]
      @line_item.save
      @food = @line_item.food
      @food.comment_number = @food.comment_number+@line_item.quantity
      @food.comment_score = @food.comment_score + @line_item.quantity*@line_item.rank
      @food.rank = @food.comment_score.to_f/@food.comment_number
      @food.save
    end
    
     value["orderinfo"].each do |k,v|
      @order = Order.find_order_by_number(v["order_id"])
      @order.rank = v["score"].to_i
      @order.comment = v["content"]
      @order.is_comment = 1
      @order.save
      @store = @order.store
      @store.sum_comment = @store.sum_comment+1
      @store.sum_score = @store.sum_score+@order.rank
      @store.rank =  @store.sum_score/@store.sum_comment.to_f
      @store.save
      @user = @order.user
      @user.integral = @user.integral + @order.total_price*10
      @user.save
    end
  end

  def the_activity_status(end_time)
      end_time < Time.now ? "已开奖" : "未开奖"
  end
  
end
