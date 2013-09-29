        # encoding: utf-8
class StoresController < ApplicationController
  # layout :resolve_layout
  #规定必须登录才可以进行店家的相关操作
  #普通用户不可以直接访问店家
  #before_filter :verify_store_login_permission ,:except => [:show, :add_fav_store, :cancel_fav_store, :add_fav_food, :cancel_fav_food, :destory_fav_food, :destory_fav_store]
  # GET /stores/1
  # GET /stores/1.json

  before_filter :is_my_store? ,:only=>[:edit,:search,:close,:open,:update,:delete_food]
  def show
    begin
      @store = Store.where(:id => params[:id],:isclose => [0,1]).first
      if @store.nil?
        #如果店家关闭或者退出平台，通过url访问到404页面
        render_404
      else
        @favoritec_count = Favorite.where(:store_id => @store.id).count(:user_id)
      end
      if params[:st]=="ok"
        @show_comments = true
        @store_comments = Message.where("store_id=?",@store.id).order("id desc").paginate(:page => params[:page], :per_page => 5)
      end
      @carts = Cart.find_my_cart(cart_id.to_s)
    end

  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(session[:store_id].to_i)
    @food = Food.new
    to_day = Time.now.to_date.to_s
    @hot_foods = {}
    @hot_foods.default = 0
    orders = Order.where("store_id = ? and DATE(created_at) = DATE(?)" , @store.id ,params[:search] == "ok"?params[:date]: Time.now.to_date.to_s )
    orders.each { |order| order.line_items.each { |line_item|  @hot_foods[line_item.food.name.to_s]+=line_item.quantity }}
    @hot_foods =  @hot_foods.sort_by{|key,value| value}.reverse
    @store_total_order_price = Order.store_total_order_price(orders)
    @orders_count = Order.where("store_id = ? and DATE(created_at) = DATE(?)",session[:store_id],params[:search] == "ok"?params[:date]:to_day).count
    @orders_fail = Order.where("store_id = ? and DATE(created_at) = DATE(?) and (order_status = ? or order_status = ?)",session[:store_id],params[:search] == "ok"?params[:date]:to_day,2,4).count
    @store_order_fail_price = Order.store_total_order_price(Order.where("store_id = ? and DATE(created_at) = DATE(?) and (order_status = ? or order_status = ?)",session[:store_id],params[:search] == "ok"?params[:date]:to_day,2,4))
    @type = params[:type].to_s.strip
    case @type
    when ""
      @type = "orders"
      if params[:search] == "ok"
        @orders =  Order.where("store_id = ? and DATE(created_at) = DATE(?)" , @store.id ,params[:date] ).paginate(:page => params[:page], :per_page => 20).order("created_at DESC")
      else
        @orders =  Order.where("store_id = ? and DATE(created_at) = DATE(?)" , @store.id , to_day).paginate(:page => params[:page], :per_page => 20).order("created_at DESC")
      end
      @max_order_id =  Order.where("store_id = ?", @store.id).order("id desc").first

      @max_order_id &&= @max_order_id.id
      @max_order_id.to_i
      render :layout => "store_manager"
    when "foods"
      render :layout => "store_manager"
    when "messages"
      @messages = Message.where("store_id=?",@store.id).order("id desc").paginate(:page => params[:page], :per_page => 7)
      render :layout => "store_manager"
    when "categories"
      @category = Category.new
      render :layout => "store_manager"
    when "finance"
      search_time = Time.parse((params[:date].to_s == "" )? Time.now.to_s : params[:date])
      @search_time = (search_time > Time.now)? Time.now : search_time
      @finance = build_finance_by_this_year(@store.id,@search_time,3)
      @sales_sum = @finance.values.sum
      render :layout => "store_manager"

    else
      @type = "orders"
      redirect_to edit_stores_path :type=>nil
    end

  end

  def store_login
    @store_user = StoreUser.where(:username => params[:name]).first
    if @store_user and params[:password] == @store_user.decrypt(@store_user.password)
      session[:store_id] = @store_user.store_id
      redirect_to "/stores/edit"
    else
      flash[:error] = "用户名或者密码不正确"
      redirect_to login_stores_path
    end
  end

  def logout
    session[:store_id] = nil
    flash[:info] = "退出成功"
    redirect_to login_stores_path
  end

  def login
    render :layout => "admin_login"
  end

  def search
    redirect_to edit_stores_path :date => params[:store][:date] ,:search => "ok"
  end

  def search_finance
    redirect_to edit_stores_path(:type => "finance",:date => params[:store][:date])
  end

  def close
    @store = Store.find(session[:store_id])
    redirect_to edit_stores_path if @store.update_attributes(:isclose => 1)
  end

  def open
    @store = Store.find(session[:store_id])
    redirect_to edit_stores_path if @store.update_attributes(:isclose => 0)
  end

  def update
    @store = Store.find(session[:store_id])
    if @store.update_attributes(params[:store])
      redirect_to "/stores/edit/orders"
    else
      redirect_to :root
    end
  end

  def delete_food
    food_id =  params[:food_id]
    if Food.find(food_id).destroy
      flash[:create_food_info] = "删除成功!"
      redirect_to "/stores/edit/foods"
    else
      flash[:create_food_info] = "删除失败!"
      redirect_to "/stores/edit/foods"
    end
  end

  def delete_category
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:create_category_info] = "删除#{@category.name}成功!"
      redirect_to "/stores/edit/categories/"
    else
      flash[:create_category_info] = "删除#{@category.name}失败!"
      redirect_to "/stores/edit/categories/"
    end
  end

  def cancel_ad
    @food = Food.find(params[:food_id])
    if @food.update_attribute(:is_recommend , 0)
      flash[:create_food_info] = "取消推荐成功"
      redirect_to "/stores/edit/foods/"
    else
      flash[:create_food_info] = "取消推荐失败"
      redirect_to "/stores/edit/foods/"
    end
  end

  def order_details
    @order = Order.find(params[:order_id])
    type = params[:type].to_i
    if type == 1
      if @order.order_status == 0
        @order.update_attributes(:order_status => "5")
        #send_confirm_message(@order)
      end
    end
    render :layout => "devise"
  end

  def order_success
    @order = Order.find(params[:order_id])
    if @order.order_status == 5 || @order.order_status == 0
      if @order.update_attributes(:order_status => 3 )
        add_sold_count(@order)
        flash[:order_info] = "恭喜您又完成了一笔交易！"
        redirect_to edit_stores_path
      else
        flash[:order_info] = "因为某种原因无法完成交易！"
        redirect_to edit_stores_path
      end
    else
      flash[:order_info] = "因为某种原因无法完成交易！"
      redirect_to edit_stores_path
    end

  end

  #用户增加收藏的店家
  def add_fav_store
    if user_signed_in?
      @store =  Store.find(params[:store_id])
      unless current_user.nil? && @store.nil?
        begin
          current_user.stores << @store
        rescue

        end
      end
      render :json => Favorite.where(:store_id => @store.id).count(:user_id)
    else
      redirect_to("/users/sign_in",:notice => "亲，必须登录后才可以进行操作哦!")
    end

  end

  #取消收藏店家
  def cancel_fav_store
    if user_signed_in?
      store = Store.find(params[:store_id])
      begin
        current_user.stores.delete(store)
      rescue
      end
      render json: Favorite.where(:store_id => store.id).count(:user_id)
    else
      redirect_to("/users/sign_in",:notice => "亲，必须登录后才可以进行操作哦!")
    end
  end

  def order_periods
    if params[:store][:task].to_s.blank?
      params[:store][:order_periods_attributes].values.each do |new_one|
        order_period = OrderPeriod.find(new_one[:id])
        if new_one[:_destroy] == "0"
          new_one.delete :id
          new_one.delete :_destroy
          order_period.update_attributes(new_one)
        else
          order_period.delete
        end
      end
    else
      new_one = params[:store][:order_periods]
      new_one.delete :_destroy
      new_one[:store_id] = session[:store_id]
      OrderPeriod.create(new_one)
    end
    redirect_to edit_stores_path
  end

  def has_new_order
    result ="0"
    the_max_id =  Order.where(:store_id=>params[:store_id].to_i).order("id desc").first.id
    result  = "1" if the_max_id >  params[:max_order_id].to_i
    render json: result
  end


  #定义后台的模板
  private

  def add_sold_count order
    order.line_items.each do |line_item|
      @food = line_item.food
      @food.sales_count += line_item.quantity
      @food.save
    end
  end


  def send_confirm_message order
    food_info = order.line_items.map { |e|"#{e.food.name}#{e.quantity}份"}
    message = "尊敬的用户您好:您在【微大学】预订的订单编号:#{order.order_number.last(6)}（" + food_info.join(";") + "）店家【#{order.store.name}】已经收到。店家会在最短时间内给您烹饪、配送。如有任何疑问请致电【#{order.store.name}】：#{order.store.tel}。感谢您对【微大学】的支持，祝您用餐愉快。【http://weidaxue.me/】"
    MobileShortMessage.send_message(order.phone,message.to_s)
    ShortPhone.create({content:message, phone_number:order.phone, store_id:order.store.id})
  end


  def resolve_layout
  end

  def get_message
    Message.all
  end

  def is_my_store?
    if session[:store_id].nil?
      flash[:error] = "请先登录"
      redirect_to login_stores_path
    end
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def build_finance_by_this_year(store_id,time,status)
    range =   (((time -time.at_beginning_of_year)/1.month)*2).round
    finance_hash = {}
    (0 .. range).each do |i|
      finance_hash.update(build_finance_by_time(store_id,time.at_beginning_of_year + i * 16.day,status))
    end
    finance_hash
  end

  def build_finance_by_time(store_id, time ,status)
    day = time.day
    finance = {}
    if day < 16
      sales_price = Order.where("store_id = ? and  order_status = ?  and created_at > ? and created_at < ?",store_id,status,time.at_beginning_of_month,time.at_beginning_of_month+ 15.day).map{ |order| order.total_price}.sum
      finance[time_hash_key time] = sales_price.to_i
    else
      sales_price  = Order.where("store_id = ? and  order_status = ?  and created_at >= ? and created_at < ?",store_id,status,time.at_beginning_of_month + 15.day ,time.at_end_of_month).map{ |order| order.total_price}.sum
      finance[time_hash_key time] = sales_price.to_i
    end
    finance
  end


  def time_hash_key time
    if time.day < 16
      time.year.to_s+"年"+ time.month.to_s + "月01日-" + time.year.to_s+ "年" + time.month.to_s + "月15日"
    else
      time.year.to_s+"年"+ time.month.to_s + "月16日" + time.year.to_s+ "年" + time.month.to_s + "月" + time.at_end_of_month.day.to_s + "日"
    end
  end

end
