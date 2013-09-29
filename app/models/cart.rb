class Cart < ActiveRecord::Base

  
  def self.add_one(cart_id,data)
    begin
      my_cart = self.find_my_cart(cart_id)
        if my_cart.blank?
           my_cart =  {data[:store_id]=>{:line_items=>{data[:food_id]=>{:count=>1,:food_name=>data[:food_name],:price=>data[:price]}},:store_name=>data[:store_name],:total_price=>data[:price].to_f}}
        else
           if my_cart[data[:store_id].to_s].blank?
              my_cart[data[:store_id]] = {:line_items=>{data[:food_id]=>{:count=>1,:food_name=>data[:food_name],:price=>data[:price]}},:store_name=>data[:store_name],:total_price=>data[:price].to_f}
           elsif my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]
              my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]["count"]+=1
              value = my_cart[data[:store_id].to_s]["total_price"] + data[:price].to_f
              my_cart[data[:store_id].to_s]["total_price"] = (format_float value)
           else
              my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s] = {:count=>1,:food_name=>data[:food_name],:price=>data[:price]}
              value = my_cart[data[:store_id].to_s]["total_price"] + data[:price].to_f
              my_cart[data[:store_id].to_s]["total_price"] = (format_float value)
           end
        end
        $redis.set(cart_id,my_cart.to_json ) 
      rescue Exception => e
        return {status:"error"}
      end
       {status:"ok"}
   end


  def self.reduce_one(cart_id,data)
    begin
      my_cart = self.find_my_cart(cart_id)
      unless my_cart.blank?
         unless my_cart[data[:store_id].to_s].blank?
            if my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]
              my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]["count"]-=1
              value = my_cart[data[:store_id].to_s]["total_price"]-data[:price].to_f
              my_cart[data[:store_id].to_s]["total_price"] = (format_float value)
              if my_cart[data[:store_id].to_s]["total_price"] <= 0
                my_cart.delete(data[:store_id].to_s)
              elsif my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]["count"] <= 0
                  my_cart[data[:store_id].to_s]["line_items"].delete(data[:food_id].to_s)
              end
           end
        end
        $redis.set(cart_id,my_cart.to_json ) 
      end
    rescue Exception => e
      return {status:"error"}
    end
    {status:"ok"}
  end
  
  def self.destroy_a_lineitem(cart_id,data)
     begin
      my_cart = self.find_my_cart(cart_id)
      unless my_cart.blank?
         unless my_cart[data[:store_id].to_s].blank?
            if my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]
              food_count = my_cart[data[:store_id].to_s]["line_items"][data[:food_id].to_s]["count"].to_i
              my_cart[data[:store_id].to_s]["line_items"].delete(data[:food_id].to_s)
              value =  my_cart[data[:store_id].to_s]["total_price"]-(data[:price].to_f*food_count)
              my_cart[data[:store_id].to_s]["total_price"] = (format_float value)
              my_cart.delete(data[:store_id].to_s)  if my_cart[data[:store_id].to_s]["total_price"] <= 0 || my_cart[data[:store_id].to_s]["line_items"].blank?
            end
        end
        $redis.set(cart_id,my_cart.to_json ) 
      end
    rescue Exception => e
      return {status:"error"}
    end
    {status:"ok"}
  end

  def self.destroy_a_store(cart_id,data)
     begin
      my_cart = self.find_my_cart(cart_id)
      unless my_cart.blank?
        my_cart.delete(data[:store_id].to_s) unless my_cart[data[:store_id].to_s].blank?
        $redis.set(cart_id,my_cart.to_json ) 
      end
    rescue Exception => e
     return {status:"error"}
    end
     {status:"ok"}
  end

  def self.find_my_cart(cart_id)
      JSON.parse($redis.get cart_id.to_s)  unless (!$redis.exists cart_id)
  end

  def self.delete_my_cart(cart_id)
      $redis.del(cart_id.to_s)
  end
  
  private 
  def self.format_float(value)
    (value * 100).round / 100.0 
  end
  
end
