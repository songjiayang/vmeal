#encoding = utf-8
class SessionsController < Devise::SessionsController
  def new
    session[:return_back] = request.referrer.to_s unless request.referrer.to_s == root_url
  end

  def create
    user = User.where(:email => params[:user][:email]).first
    session[:users_redirect] = params["user_redirect"]
    if !user.nil?
      if user.valid_password?(params[:user][:password])
        if !user.confirmed?
          user.skip_confirmation!
        end
        sign_in(user)
        redirect_to(after_sign_in_path_for user)
      else
        @notice = "您输入的邮箱或者密码有错误！"
        redirect_to("/users/sign_in",:notice => @notice)
      end
    else
      @notice = "您输入的邮箱不存在，请注册后登录！"
      redirect_to("/users/sign_in",:notice => @notice)
    end
  end

  private

  def after_sign_in_path_for user
    if session[:return_back].to_s != "http://" + request.host_with_port.to_s + "/users/sign_in"
      if !session[:return_back].nil?
        if session[:return_back].to_s == "http://" + request.host_with_port.to_s + "/locate"
          "/"
        else
          return session[:return_back]
        end
      elsif session[:users_redirect].to_i == 1
        request.referrer.to_s
      else
        "/"
      end
    else
      "/"
    end
  end

end
