#encoding : utf-8
class ApplicationController < ActionController::Base
  
  before_filter :set_page # at the top and then
  protect_from_forgery

  protected

  def cart_id
     unless session[:cart_id]
       current_user ? session[:cart_id] = current_user.id :  session[:cart_id] = session[:session_id]
     end  
     session[:cart_id]
  end

  def verify_store_login_permission
    unless user_signed_in? && !current_user.store.nil?
      redirect_to("/users/sign_in",:notice => "亲，必须登录后才可以进行操作哦!") 
    end
  end

  def verify_user_login_permission
      redirect_to("/users/sign_in",:notice => "亲，必须登录后才可以进行操作哦!") unless user_signed_in?
  end

  def verify_not_allow_action
    redirect_to :root
  end

  def set_page
    unless request.referer.nil?
        unless request.referer.include?('/users/sign')
          session[:return_to] = request.referer
        end
    end 
  end

  def authenticate_with_admin
    unless session[:admin]
         flash[:error] = "You must be logged in to access this System"
         redirect_to login_admins_path # halts request cycle
      end
  end

  def locate_school
      cookies[:school] = { :value => School.first.name, :expires => 7.day.from_now } unless cookies[:school]
      cookies[:school]
  end

  def set_locate_school(school)
    cookies[:school] = { :value =>school.to_s, :expires => 7.day.from_now }
    school.to_s
  end


  private

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && (resource.is_store == 1)
      center_stores_path
    else
       super
    end
  end

  def after_sign_in_path_for(resource_or_scope)
       (session[:where_go_to].nil?) ? "/" : session[:where_go_to].to_s
  end

end
