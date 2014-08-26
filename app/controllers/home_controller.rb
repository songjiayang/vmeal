class HomeController < ApplicationController

  def index
    unless cookies[:school]
      redirect_to '/locate'
    else
      @stores = Store.stores_of_a_school(cookies[:school])
      @phone_stores = @stores.select{|store| store.isphone == 2}
      @net_stores = @stores - @phone_stores
      @hot_foods = Food.hot_foods(cookies[:school])
      @users_count = User.numbers(refresh = true)
      @food_ads = Ads.all_ads(cookies[:school],2)
      @jd_ads = Ads.all_ads(cookies[:school],1)
      @notices = Notice.order("updated_at desc").limit(5)
      login_by_qq unless params[:code].nil?
    end
  end

  def sina
    unless params[:code].nil?
      client = WeiboOAuth2::Client.new
      access_token = client.auth_code.get_token(params[:code].to_s)
      unless access_token.nil?
        session[:uid] = access_token.params["uid"]
        session[:access_token] = access_token.token
        session[:expires_at] = access_token.expires_at
        @user = User.find_by_uid(session[:uid].to_s)
        user_infor = client.users.show_by_uid(session[:uid].to_i)
        if @user
          @user.image_url_file_name = user_infor.profile_image_url
          @user.username = user_infor.name
          @user.save
          sign_in(@user)
        else
          session[:need_binding] = true
          session[:login_by_other] = {:user_type =>"sina",:uid =>session[:uid],:username =>user_infor.name,:image_url => user_infor.profile_image_url}
        end
      end
    end
    redirect_to root_path
  end

  def show_stores
    @sto_categories = StoCategory.all
  end

  def location
  end

  def qingan
   @qingan =  Qingan.new
    render :layout => "devise"
  end

  def signup
    @qingan = Qingan.new(params[:qingan])
    if @qingan.save
      flash[:qingan] =  "恭喜你报名成功，我们会尽快联系您！"
      redirect_to qingan_home_index_path
    else
      flash[:qingan] =  "亲，请填写正确的信息再报名！"
      redirect_to qingan_home_index_path
    end
  end

  def set_location
      school = School.find(params[:id])
      if school
         set_locate_school(school.name)
         redirect_to root_path
      else
         redirect_to '/locate'
      end
  end

private
  def login_by_qq
    begin
      httpstat=request.env['HTTP_CONNECTION']
      qq = Qq.new
      token = qq.get_token(params[:code],httpstat)
      qq_user_infor = qq.get_user_info(token)
      if @user = User.find_by_uid(qq_user_infor["nickname"].to_s + qq_user_infor["figureurl"].to_s)
        sign_in @user
      else
        session[:need_binding] = true
        session[:login_by_other] = {:user_type =>"qq",:uid =>qq_user_infor["nickname"].to_s + qq_user_infor["figureurl"].to_s,:username =>qq_user_infor["nickname"],:image_url =>qq_user_infor["figureurl_2"]}
        # qq.add_share(token,"微大学你身边的外卖专家","http://www.weidaxue.me","我正在使用微大学订餐平台",'“微大学”结合B2B,B2C网络订餐的概念，为餐厅提供一体化运营的解决方案，致力于推进餐饮行业信息化的发展进程 http://weidaxue.me 。','http://tp3.sinaimg.cn/2969909902/180/22821137424/1',"微大学","http://www.weidaxue.me")
      end
    rescue Exception =>e
      redirect_to root_path
    end
  end
end
