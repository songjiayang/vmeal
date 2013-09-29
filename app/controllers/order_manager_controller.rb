#encoding:utf-8

include OrdersHelper
class OrderManagerController < ApplicationController
  before_filter :is_super_men? ,:only => [:index, :show, :destroy1, :midify_status,:set_be_watered,:search,:set_user_is_ok]
  def index
    @orders = Order.where("order_status<4 ").order("created_at DESC")
    @order = Order.new
  end

  def has_order
    if Order.has_new?
      Order.clear_status
      render :json=>{:status=>"OK"}
    else
      render :json=>{:status=>"NO"}
    end
  end

  def has_store_order
    store_orders=Order.where("order_status=1 and store_id=?",Integer(params[:id]))
    if store_orders.size > 0 then
      render :json=>{:status=>"OK"}
    else
      render :json=>{:status=>"NO"}
    end
  end

  def show
    @order = Order.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  def destroy1
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to "/order_manager"
  end

  def midify_status
    @order = Order.find(params[:id])
    @order.order_status = @order.modify_status
    @order.save
    redirect_to  '/order_manager'
  end

  def set_be_watered
    @order = Order.find(params[:id])
    @order.order_status = 5
    @order.save
    redirect_to  admin_order_path @order ,notice:"#编号为{@order.order_number}的状态修改成功"
  end

  #在这里执行搜索方法
  def search
    #render json: parse_time(params[:order],2)
    @orders = Order.search(parse_time(params[:order],1),parse_time(params[:order],2),Order.translate_status_to_i(params[:order][:order_status]))
    @order = Order.new

  end

  def set_user_is_ok
    @order = Order.find(params[:id])
    @order.order_status = 1
    @order.save
    @user = @order.user
    @user.is_ok = 1
    @user.save
    redirect_to  "/order_manager"  ,notice:"#编号为{@order.order_number}已验证通过！"
  end

  private

  def is_super_men?
    if session[:super_men].nil?
      redirect_to login_super_men_path  ,notice:"小贼，休想逃过我的检查"
    end
  end
end
