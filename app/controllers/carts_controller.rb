class CartsController < ApplicationController
  
   def action
     case params[:type].to_s.to_i
        when 0
          render :json => Cart.add_one(cart_id.to_s,params)
        when 1
          render :json =>Cart.reduce_one(cart_id.to_s,params)
        when 2
          render :json =>Cart.destroy_a_lineitem(cart_id.to_s,params)
        when 3
          render :json =>Cart.destroy_a_store(cart_id.to_s,params)
        else 
         render  :json =>Cart.add_one(cart_id.to_s,params)
     end
   end
end
