#encoding: utf-8
class OrdersController < ApplicationController
  def new
    @carts = current_carts
  end

  def show
    order = Order.find(params[:id])
    render json: {:order_id => order.order_number,
       :store_name => order.store.name,
       :money => order.total_price,
       :pay_type => order.pay_type,
       :created_at => order.created_at.localtime.to_s(:db),
       :sent_time => order.send_time,
       :status => '下单成功',
       :id => order.id
     }
  end

  def apply_fail_order
    @order = Order.find(params[:order_id])
    if @order.created_at.to_date < Date.today
      flash[:order_info]= "只能对当天的订单进行弃单处理!"
      redirect_to "/stores/edit/orders"
    else
      @order.fail_comment = params[:fail_comment]
      @order.order_status = 2
      if @order.save
        flash[:order_info]= "申请成功，请等待后台管理员处理!"
        redirect_to "/stores/edit/orders"
      else
        flash[:order_info]= "申请失败!"
        redirect_to "/stores/edit/orders"
      end
    end
  end

  def create
    user_info = params[:order]
    default_comment = "亲，还有什么需要跟店家交代的么？（100字以内!）"
    user_info[:comment] = "" if user_info[:comment] == default_comment
    user_info[:user_id] = current_user.id
    if user_info[:pay_type].to_s == "积分支付"
        if  current_user.integral.to_i > user_info[:integral].to_i
            if Cart.find_my_cart(cart_id).keys.join(",") == "20"
                new_orders = Order.create_with_a_cart(cart_id,user_info)
                if !new_orders.blank? && update_integral(current_user,params[:integral].to_i)
                  flash[:new_orders] = new_orders
                  redirect_to "/users/orders/building"
                else
                  flash[:alert] = '亲，您的购物车没有食品，请点餐后提交提交！'
                  redirect_to bill_users_path
                end
            else
               flash[:duihuan] = '积分支付暂时仅限乐莱基餐品使用!'
               redirect_to bill_users_path
            end
        else
          flash[:duihuan] = '积分不够不能参与兑换，赶快去吃点吧'
          redirect_to bill_users_path
        end
    else
      new_orders = Order.create_with_a_cart(cart_id,user_info)
      unless new_orders.blank?
        flash[:new_orders] = new_orders
        redirect_to "/users/orders/building"
      else
        flash[:alert] = '亲，您的购物车没有食品，请点餐后提交提交！'
        redirect_to bill_users_path
      end
    end
  end



  def do_one_order_comment
    @order = Order.where(:id=>params[:orderid],:user_id=>current_user.id).first
    if @order and @order.update_attributes(:is_comment => 1) and Message.create({comment:params[:order][:comment],user_id:current_user.id,store_id:@order.store_id})
      back_score_from_comment(@order.total_price)
      flash[:user_order_message] = "评论成功"
      redirect_to "/users/orders/building"
    else
      flash[:user_order_message] = "评论失败"
      redirect_to "/users/orders/building"
    end
  end

  def do_fail_order
    unless params[:id].nil?
      order = Order.find(params[:id])
      if order.order_status == 1 then
        order.order_status = 2
        order.save!
      end
    end
    redirect_to admins_orders_path
  end

  def recover_order
    unless params[:id].nil?
      order = Order.find(params[:id])
      if order.order_status == 2 then
        order.order_status = 1
        order.save!
      end
    end
    redirect_to admins_orders_path
  end

  private

  def update_integral(user,count_integral)
    integral = (user.integral - count_integral >= 0)? (user.integral - count_integral) : 0
    user.update_attributes(integral: integral )
  end

  def varify_token
    if user_signed_in?
    else
      redirect_to :root
    end
  end

  def add_sold_count order
    order.line_items.each do |line_item|
      @food = line_item.food
      @food.sales_count += line_item.quantity
      @food.save
    end
  end

  def back_score_from_comment(money)
    change_score = money.to_i
    ScoreHistories.create({user_id:current_user.id,change_type:2,operate:"[微大学]订餐评论",detail:"订单交易成功并评论赠送积分",change_score:change_score})
    current_user.integral += change_score
    current_user.save
  end

end
