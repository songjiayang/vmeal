#encoding = utf-8
# include UsersHelper
class UsersController < ApplicationController

  # before_filter :verify_user_login_permission ,:only =>[:create_user_weibo,:is_login_in_uid,
  #                                          :register_email,:resend_email,:send_email,:edit_user_password,:bill,:eat_one,
  #                                          :personal_basic,:personal_address,:personal_collect,:personal_mail]

  # before_filter :verify_user_login_permission ,:except =>[:create_user_weibo,:is_login_in_uid,
  #                                          :register_email,:resend_email,:send_email,:edit_user_password,:bill,:eat_one,
  #                                          :personal_basic,:personal_address,:personal_collect,:personal_mail]

  #用户积分计算
  #通过获取当前数据库中的积分
  #加上本次的消费积分

  before_filter :before_update_password? ,:only=>[:update]
  before_filter :verify_user_login_permission ,:only => [:qiandao,:welfare,:personal_basic,:personal_address,:personal_collect,:personal_mail,:personal_order,:address_create]
  def qqlogin
    redirect_to Qq.redo("get_user_info,list_album,upload_pic,add_share")
  end

  def otherlogin
    unless params[:type]=="0"
      unless params[:email].nil? || params[:password].nil? || session[:login_by_other].nil?|| !params[:email].to_s.include?("@")
        if @user = User.find_by_email(params[:email])
          render :json => {:status => "fail",:error_msg => "此邮箱已经绑定"}
        else
          if @user = User.find_by_uid(session[:login_by_other][:uid].to_s)
            sign_in(@user)
          else
            @user = User.new
            @user.email = params[:email]
            @user.username = session[:login_by_other][:username].to_s
            @user.password = params[:password]
            @user.image_url_file_name = session[:login_by_other][:image_url]
            @user.uid = session[:login_by_other][:uid]
            @user.skip_confirmation!
            if @user.save
              sign_in(@user)
              render :json => {:status => "ok"}
            else
              render :json => {:status => "fail",:error_msg => "绑定失败,请填写正确的邮箱地址!"}
            end
          end
        end
      else
        render :json => {:status => "fail",:error_msg => "绑定失败,请填写完整的信息!"}
      end
    else
      unless session[:login_by_other].nil?
        if @user = User.find_by_uid(session[:login_by_other][:uid].to_s)
          sign_in(@user)
        else
          @user = User.new
          @user.email = "#{[*?0..?9,*?a..?z].sample(8).join}@weidaxue.me"
          @user.username = session[:login_by_other][:username].to_s
          @user.password = "123456"
          @user.image_url_file_name = session[:login_by_other][:image_url]
          @user.uid = session[:login_by_other][:uid]
          @user.skip_confirmation!
          if @user.save
            sign_in(@user)
            render :json => {:status => "ok"}
          else
            render :json => {:status => "fail",:error_msg => "绑定失败"}
          end
        end
      end
    end
  end

  def sina_login
    client = WeiboOAuth2::Client.new
    redirect_to client.authorize_url
  end

  def get_user_qq_info

  end

  def qiandao
    unless current_user.is_signed
      current_user.signin_number = 0  if current_user.is_not_continuous
      if  current_user.signin_number.to_i == 0
        current_user.signin_number = 1
        ScoreHistories.create({user_id:current_user.id,change_type:1,operate:"[微大学]签到",detail:"连续签到1天",change_score:1})
        current_user.integral += 1
        current_user.save
      elsif current_user.signin_number == 1.to_s
        current_user.signin_number = 2
        ScoreHistories.create({user_id:current_user.id,change_type:1,operate:"[微大学]签到",detail:"连续签到2天",change_score:2})
        current_user.integral += 2
        current_user.save
      else
        current_user.signin_number = current_user.signin_number.to_i+1
        ScoreHistories.create({user_id:current_user.id,change_type:1,operate:"[微大学]签到",detail:"连续签到3天或者以上",change_score:3})
        current_user.integral += 3
        current_user.save
      end
      render json: {"number"=>current_user.signin_number.to_i,"score"=>current_user.integral}
    else
      render json: "今日已签到，不能再签了！！"
    end

  end

  def add_integral(integral)
    u = User.find(current_user.id)
    u.integral = u.integral + integral
    u.save
  end

  def destory_favorite_food
    #删除某一个收藏的食品
    if FavoriteFood.where(:food_id => params[:food_id]).first.destroy
      redirect_to person_center_fav_food_users_path
      flash[:notice] = '删除收藏食品成功'
    end
  end

  def destory_favorite_store
    #删除某一个收藏的食品
    if Favorite.where(:store_id => params[:store_id]).first.destroy
      redirect_to person_center_fav_store_users_path
      flash[:notice] = '删除收藏店家成功'
    end
  end

  def address_create
    addr = SendAddress.where("user_id=? and id=?",current_user.id,params[:address][:id])
    if addr.blank?
      @send_address = SendAddress.new(params[:address])
      @send_address.user_id = current_user.id
      @send_address.save
      flash[:notice] = "送餐地址创建成功!"
    else
      p params[:address]
      addr.first.update_attributes(params[:address])
      flash[:notice] = "送餐地址修改成功!"
    end
    redirect_to  address_users_path
  end

  def eat_one
    @cart = Cart.new
    @cart.save
    session[:carts_id] << @cart.id
    @line_item = LineItem.new
    @line_item.food_id = params[:id]
    @line_item.cart_id = @cart.id
    @line_item.save
    if user_signed_in?
      session[:where_go_to] = nil
      redirect_to   bill_users_path(:id=>@line_item.id)
    else
      session[:where_go_to] = "/users/bill?id="+@line_item.id.to_s
      redirect_to("/users/sign_in",:notice => "亲，必须登录后才可以进行操作哦!")
    end

  end

  #删除用户地址,删除默认的用户地址的时候用户表中要进行相关的处理
  def destory_address
    @send_addresses = SendAddress.find(params[:address_id])
    if @send_addresses.id == current_user.default_address_id
      if @send_addresses.destroy && current_user.update_attribute(:default_address_id, -1)
        redirect_to address_users_path
        flash[:notice] = '删除地址成功'
      end
    else
      if @send_addresses.destroy
        redirect_to address_users_path
        flash[:notice] = '删除地址成功'
      end
    end
  end

  #Ajax增加用户地址
  def add_user_address
    @send_address = SendAddress(params[:send_address])
    @send_address.save
  end

  def do_one_order_comment
    @order = Order.find(params[:id])
  end

  def save_order_comment
    status = {}
    begin
      do_save_comments params
      status[:type] =1
      render json: status
    rescue exception =>e
      status[:type] = 0
      render json: status
    end
  end

  def person_center
    #查看当前用户完成的订单
    @user_finish_order = Order.where(:user_id => current_user.id).select("COUNT(id) AS total ").first.total
  end

  def person_center_order_uncomment
    @uncomment_order = Order.where("is_comment = 0 and user_id = ?",current_user.id).order("created_at DESC").page(params[:page]).per(12)
  end

  def person_center_order_history
    @history_order = Order.where("is_comment = 1 and user_id = ?",current_user.id).order("created_at DESC").page(params[:page]).per(12)
  end

  def person_center_fav_food
    @fav_foods = current_user.foods
  end

  def person_center_fav_store
    @fav_stores = current_user.stores
  end

  def do_one_complaint
    @order = Order.find(params[:id])
  end

  #当前用户的留言
  def person_center_message
    @messages = Message.where(:user_id => current_user.id)
    unless @messages.blank?
      @reply = @messages.first.reply
    end

  end

  def register_email
    if !params[:register_token].nil?
      render :layout => "devise"
    else
      redirect_to "/"
    end
  end

  #用户对菜的评论
  def person_center_comment
    @orders = Order.where(:user_id => current_user.id ,:is_comment =>1)
  end

  def bill
    if current_user
      session[:user_path] = nil?
      @send_addresses = SendAddress.where(:user_id => current_user.id)
      @order=Order.new
      @cart_id =  cart_id
      @carts = Cart.find_my_cart(cart_id.to_s)
      flash[:notice]="你的购物车为空，赶快去品尝吧！" unless @carts
      render :layout => "application"
    else
      session[:user_path] = "/users/bill"
      flash[:notice]=" 下单请先登录微大学"
      redirect_to "/users/sign_in"
    end
  end

  #当前用户地址管理
  def person_center_address
    @send_addresses = SendAddress.where(:user_id => current_user.id)
  end

  def person_center_info
    if current_user.default_address_id == -1
      @default_send_address = nil
    else
      @default_send_address = SendAddress.find(current_user.default_address_id)
    end

  end

  #用户默认地址的处理
  def set_default_address
    current_user.default_address_id = params[:default_address_id]
    if current_user.save
      redirect_to address_users_path
      flash[:notice] = '默认地址设置成功'
    end
  end

  def score_histories
    @type = params[:type].to_s
    if @type == ""
      @score_histories = ScoreHistories.where(:user_id=>current_user.id).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif @type == "add"
      @score_histories = ScoreHistories.where("user_id=? and change_type != 3",current_user.id).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else  @type =="sub"
      @score_histories = ScoreHistories.where(:user_id=>current_user.id,:change_type=>3).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def welfare
    @type=params[:type].to_s
    if @type == ""
      @goods = current_user.activities.paginate(:page => params[:page], :per_page => 10)
    else
      @good_address = (current_user.good_address || GoodAddress.new)
    end
  end

  def good_address_create
    @good_address = params[:good_address]
    if @good_address[:real_name].blank? || @good_address[:address].blank? || @good_address[:tel_number].blank?
      flash[:error] = "信息填写不完善，请填写完整！"
      redirect_to "/users/welfare/address_new"
    elsif current_user.good_address
      @my_address = current_user.good_address
      @my_address.update_attributes(@good_address)
      redirect_to "/users/welfare/address"
    else
      @my_address = GoodAddress.new(@good_address)
      @my_address.save
      redirect_to "/users/welfare/address"
    end

  end

  def person_center_password
    @user = current_user
  end

  # def user_complaints
  # @complaints = Complaint.where("user_id =?",current_user.id)
  # end

  def do_complaint
    @can_complaint = current_user.all_un_complainted_orders.size>0
  end

  #更新用户的密码（包括店家和用户）
  def update
    @user = current_user
    if @user.update_with_password(params[:user])
      flash[:notice] = "恭喜你修改密码成功,请重新登录!"
      redirect_to :controller=>'sessions' ,:action=>'new'
    else
      flash[:update_input_old_password] = ""
      flash[:update_password_error1] = "原密码输入不正确!"
      redirect_to account_users_path
    end
  end

  def change_avatar
    @user = current_user
    unless params[:user].blank?
      @user.image_url = params[:user][:image_url]
      if @user.save!
        flash[:notice] = "头像上传成功"
        redirect_to home_users_path
      else
        redirect_to :root
      end
    else
      flash[:notice] = "头像上传失败，请检查是否选择文件"
      redirect_to home_users_path
    end
  end

  #点击更新数量
  def change_line_item_quantity
    if params[:op] == "add"
      line_item = LineItem.find(params[:id])
      current_line_item_quantity = line_item.quantity
      line_item.update_attribute(:quantity , current_line_item_quantity + 1)
      redirect_to(bill_users_path(:id => get_cart_id))
    elsif params[:op] == "del"
      line_item = LineItem.find(params[:id])
      if line_item.quantity > 1
        current_line_item_quantity = line_item.quantity
        line_item.update_attribute(:quantity , current_line_item_quantity - 1)
        redirect_to(bill_users_path(:id =>get_cart_id))
      elsif line_item.quantity == 1
        if line_item.cart.line_items.size == 1
          if line_item.destroy && line_item.cart.destRoy
            remove_one_cart_id_from_session line_item.cart.id
            redirect_to bill_empty_users_path
          end
        else
          if line_item.destroy
            redirect_to(bill_users_path(:id =>get_cart_id))
          end
        end
      end
    end
  end

  #创建微博用户不用邮箱确认，直接注册
  def create_user_weibo
    @user = User.new
    @user.email = params[:email]
    @user.username = params[:username]
    @user.password = params[:password]
    @user.image_url_file_name=params[:imageurl]
    @user.uid = params[:uid]
    @user.skip_confirmation!
    respond_to do |format|
      if @user.save
        sign_in(@user)
        format.json { render json: {:status=>"ok"} }
      else
        format.json { render json: {:status=>"error",:notice => "亲，您已经注册过了，可以直接登录！"} }
      end
    end
  end

  #根据UID判断用户是否存在
  def is_login_in_uid
    @weibo_user = User.where(:uid => params[:uid]).first

    respond_to do |format|
      if !@weibo_user.nil?
        sign_in(@weibo_user)
        format.json { render json: {:status=>"ok"} }
      else
        format.json { render json: {:status=>"error"} }
      end
    end
  end

  def resend_email
    @unconfirm_email = params[:email]
    if @unconfirm_email.nil?
      redirect_to :root
      return
    end
    render :layout => 'devise'
  end

  #重新发送邮件
  def send_email
    # email = params[:email]
    # user = User.where(:email => email).first
    # # user.skip_confirmation!
    # if !user.nil?
    # if user.send_confirmation_instructions
    # redirect_to resend_email_users_path(flash[:notice] = "激活邮件发送成功，请到邮箱激活后进行下一步操作!")
    # end
    # else
    # redirect_to resend_email_users_path(flash[:notice] = "亲，这个邮箱没有注册哦，请跳转到注册页面重新注册！")
    # end
  end

  def person_center_integral
    @exchange_goods = ExchangeGood.all
    @min_integral =  ExchangeGood.minimum("least_integral")
  end

  def integral_bill
    if user_signed_in?
      @exchange_goods = ExchangeGood.find(params[:id])
      @exchange_number =(params[:number].nil?)? 1 : params[:number].to_i
      @send_addresses = SendAddress.where(:user_id => current_user.id)
      if current_user.default_address_id != -1
        @default_address = SendAddress.find(current_user.default_address_id)
      else
        @default_address = nil
      end
    else

    end
  end

  def person_center_integral_history
    @integral_history = IntegralConsumerRecord.where(:user_id => current_user.id)
  end

  def  create_exchange_good
    icr = IntegralConsumerRecord.new
    icr.user_id = current_user.id
    icr.exchange_goods_id = params["exchange_goods_id"]
    icr.number= params["number"]
    icr.address = params["address"]
    icr.phone = params["phone"]
    icr.phone_bk = params["phone_bk"]
    icr.name = params["name"]
    if current_user.integral - params["consumer"].to_i <0
      redirect_to integral_bill_users_path(:id => params["exchange_goods_id"],:notice => "亲，你的积分不足以兑换奖品哦，请继续努力！")
    else
      current_integral = (current_user.integral - params["consumer"].to_i >=0)? current_user.integral - params["consumer"].to_i : 0
      if icr.save && current_user.update_attribute(:integral,current_integral)
        redirect_to person_center_integral_users_path(flash[:notice] = "恭喜你，奖品兑换成功！您将会在1-3个工作日内收到兑换奖品。")
      else
        redirect_to integral_bill_users_path(:id => params["exchange_goods_id"],:notice => "亲，想兑换奖品，一定要填写正确的信息哦！")
      end
    end
  end

  def change_exchange_good_number
    if params[:op] == "add"
      @exchange_number = params["number"].to_i + 1
      if  ExchangeGood.find(params[:id]).least_integral * @exchange_number > current_user.integral
        redirect_to integral_bill_users_path(:id =>params[:id] ,:number => @exchange_number,:notice => "您的积分不足以兑换该数量的奖品！请修改后兑换！" )
        return
      end
    elsif params[:op] == "del"
      if  params["number"].to_i == 1
        redirect_to integral_bill_empty_users_path
        return
      end
      @exchange_number =  params["number"].to_i - 1
      if  ExchangeGood.find(params[:id]).least_integral * @exchange_number > current_user.integral
        redirect_to integral_bill_users_path(:id =>params[:id] ,:number => @exchange_number,:notice => "您的积分不足以兑换该数量的奖品！请修改后兑换!" )
        return
      end
    end
    redirect_to integral_bill_users_path(:id =>params[:id] ,:number => @exchange_number)
  end

  ##############################改版页面新的action###################################

  def personal_basic
    @tab_index = 1
    @favorite_number = Favorite.where(:user_id => current_user.id).count
    if params[:without_one_month] == "ok"
      @without_orders = Order.find_by_sql(["SELECT * FROM orders WHERE DATE_SUB(CURDATE(), INTERVAL 30 DAY) >= date(updated_at) AND user_id =?",current_user.id])
    else
      @orders = Order.find_by_sql(["SELECT * FROM orders WHERE DATE_SUB(CURDATE(), INTERVAL 30 DAY) <= date(updated_at) AND user_id =?",current_user.id])
    end
  end

  def personal_address
    @tab_index = 5
    @send_addresses = SendAddress.where(:user_id => current_user.id)
  end

  def personal_collect
    @tab_index = 3
    @type = params[:type].to_s
    case @type
    when "stores"
      @favorite_stores = Favorite.where(:user_id => current_user.id)
    when "foods"
      @favorite_foods = current_user.favorite_foods
    else
      @type = "stores"
      @favorite_stores = Favorite.where(:user_id => current_user.id)
    end
  end

  def personal_mail
    @tab_index = 4
    status = params[:status].to_s
    if status == "readed"
      @status = "readed"
      @mail = MailIndexUser.where(:receiver_user_id => current_user.id ,:send_status => 0 , :receive_status => 0 , :read_status => 1)
    elsif status == "unread"
      @mail = MailIndexUser.where(:receiver_user_id => current_user.id ,:send_status => 0 , :receive_status => 0 , :read_status => 0)
    else
      redirect_to mails_users_path(:status=>"unread")
    end
  end

  def personal_order
    @tab_index = 2
    status = params[:status].to_s
    if status == "in_one_month"
      @order_status = 2
      @orders = Order.where("is_comment = 1 and  user_id = ? and created_at > ?",current_user.id,30.days.ago).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    elsif status == "before_one_month"
      @order_status = 3
      @orders = Order.where("is_comment = 1 and  user_id = ? and created_at < ?",current_user.id,30.days.ago).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    elsif status == "building"
      @order_status = 1
      @orders = Order.where("(order_status <= 3 or order_status =5) and is_comment = 0  and user_id = ?",current_user.id).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    else
      redirect_to orders_users_path(:status=>"building")
    end
  end

  def personal_account
    @tab_index = 6
    @user = current_user
  end

  def create_message
    @message = Message.create(params[:message])
    @message["user_id"]=current_user.id
    if @message.save
      redirect_to(basic_users_path ,:notice => "留言成功")
    else
      redirect_to(basic_users_path ,:notice => "留言失败")
    end
  end

  def read_mail
    @mail_content = MailIndexUser.find(params[:id])
    @mail_content.update_attributes(:read_status => 1)
    mail_content = StationMail.find(@mail_content.mail_id).content
    render json:mail_content
  end

  def delete_mail
    @mail_content = MailIndexUser.find(params[:id])
    redirect_to mails_users_path if @mail_content.update_attributes(:receive_status => 1)
  end

  def drop_order
    order = Order.find(params[:order_id])
    if order.in_five_minutes?
      if  order.pay_type == "积分支付"
      #恢复积分
      recover_integral order
      end
      flash[:user_order_message] = "取消订单成功"
      redirect_to "/users/orders/building" if Order.find(params[:order_id]).update_attributes(:order_status => 4)
    else
      flash[:user_order_message] = "取消订单务必在下单后五分钟之内操作！否则请联系店家进行操作。"
      redirect_to "/users/orders/building"
    end
  end


  private

  def recover_integral order
    integral = (order.total_price * 12.5).round
    current_user.update_attributes(integral: (current_user.integral + integral))
  end

  def before_update_password?
    filter_result = false
    flash[:update_input_old_password] = params[:user][:current_password].to_s
    flash[:update_input_new_password] = params[:user][:password].to_s
    flash[:update_input_new_password_confirmation] = params[:user][:password_confirmation].to_s
    if params[:user][:current_password].blank?
      flash[:update_input_old_password] = ""
      flash[:update_password_error1] = "原始密码输入不能为空!"
    elsif params[:user][:password].strip.size<8 || params[:user][:password].strip.size >18
      flash[:update_password_error2] = "密码长度为8-18位的字母或数字!"
      flash[:update_input_new_password] = ""
      flash[:update_input_new_password_confirmation] = ""
    elsif params[:user][:password].strip != params[:user][:password_confirmation].strip
      flash[:update_password_error3] = "两次输入密码不匹配!"
      flash[:update_input_new_password_confirmation] = ""
    elsif params[:user][:current_password].strip == params[:user][:password].strip
      flash[:update_password_error2] = "新密码和老密码不能相同!"
      flash[:update_input_new_password] = ""
      flash[:update_input_new_password_confirmation] = ""
    else
      filter_result = true
    end
    filter_result ? true : (redirect_to account_users_path)
    # render :layout => "application"
  end

  def get_cart_id
    Cart.find(session[:cart_id]).line_items.first.id
  end

  def verify_user_login_permission
    if current_user.nil? then
      session[:return_back] = request.path
      redirect_to new_user_session_path
    end
  end

end
