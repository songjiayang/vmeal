#encoding : utf-8
class RegistrationsController < Devise::RegistrationsController

  #自己定义一个注册后跳转的路径
  protected
  def after_inactive_sign_up_path_for(resource)
    begin
      resource.update_attributes(integral:  10)
      flash[:notice] = "恭喜您注册成功，请直接登录！"
      "/users/sign_in"
    rescue Exception => e
      "/users/sign_up"
    end
  end

  #定义更新信息后跳转的页面
  #重写了注册的controler
  protected

  def after_update_path_for(resource)
    person_center_info_users_path
  end

end
