#ecoding : utf-8
class UserMailer < ActionMailer::Base
  
  default :from => "songjiayang1@gmail.com"
 
  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/login"
    mail(:to => user.email, :subject => "欢迎注册微大学")
  end
end
