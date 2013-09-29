#encoding : utf-8
class LogisticsController < ApplicationController
  def center
    if session[:username].nil?
      redirect_to "/logistics/login"
    else
      if session[:username].user_type==0
        @orders=session[:username].get_deal_orders(0)
        respond_to do |format|
          format.html # index.html.erb
        end
      else
        @orders=session[:username].get_deal_orders(1)
        respond_to do |format|
          format.html # index.html.erb
        end
      end

    end
  end

  def orderinfo
    if session[:username].nil?
      redirect_to "/logistics/login"
    else
      @type=session[:username].user_type
      @order=Order.find(params[:orderid])
      @lineitem=LineItem.where(:order_id=>@order.id)
    end
  end

  def login

  end

  def history
    if session[:username].nil?
      redirect_to "/logistics/login"
    else
      @orders=session[:username].get_history_orders session[:username].user_type
      respond_to do |format|
      format.html # index.html.erb
      end
    end
  end

  def islogin
    @foodsenter=FoodSenter.where(:login_name=>params[:username],:password=>params[:password]).first
    session[:username]=@foodsenter
    if @foodsenter.nil?
      render json: {:error=>"帐号或密码错误"}
    else
      render json: {:stuts=>"OK"}
    end
  # render json:@foodsenter
  end

  def changeorder
    if session[:username].nil?
      redirect_to "/logistics/login"
    else
      @order = Order.find(params[:id])
      @order.order_status = @order.modify_status
      if @order.save
        redirect_to "/logistics/orderinfo?orderid=#{@order.id}"
      else
        redirect_to "/logistics/orderinfo?orderid=#{params[:id]}"
      end
    end
  end

  def filedorder
    if session[:username].nil?
      redirect_to "/logistics/login"
    else

      @order = Order.find(params[:id])
      if(@order.order_status==4)
        redirect_to "/logistics/orderinfo?orderid=#{@order.id}"
      else
      @order.order_status = 5
      end

      if @order.save
        redirect_to "/logistics/orderinfo?orderid=#{@order.id}"
      else
        redirect_to "/logistics/orderinfo?orderid=#{params[:id]}"
      end
    end
  end

end
