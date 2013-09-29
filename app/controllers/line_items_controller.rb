class LineItemsController < ApplicationController
  
 
  def create
    food = Food.find(params[:food_id])
    @cart = current_cart(food)
    @line_item = @cart.add_food(food.id)
    render json:@line_item
  end

  def modify
    task = params[:task].to_s
    case task
      when "increase_one" then increase_one
      when "reduce_one" then reduce_one
      when "destroy_one" then destroy_one
      else render json:current_carts
    end
  end
  

  private
  def destroy_one
   @line_item = LineItem.find(params[:id])
   @line_item.cart.line_items.size
    if @line_item.cart.line_items.size>=2
      @line_item.destroy      
    else
      remove_one_cart_id_from_session @line_item.cart.id if @line_item.cart.destroy
    end
    render json:@line_item.id
  end

  def increase_one
    line_item = LineItem.find(params[:id])
    line_item.quantity+=1
    line_item.save
    render json:current_carts
  end

  def reduce_one
    line_item = LineItem.find(params[:id])
    if line_item.quantity==1
      if line_item.cart.line_items.size>1
        line_item.destroy
      else
        remove_one_cart_id_from_session line_item.cart.id
        line_item.cart.destroy
      end

    else
      line_item.quantity-=1
      line_item.save
    end
    render json:current_carts
  end

end
