#encoding: utf-8
class VdaxueMailer < ActionMailer::Base
  default from: "service@weidaxue.me"
  def welcome_email(user)
    @user = user
    @url  = "http://weidaxue.me/users/sign_in"
    mail(:to => user.email, :subject => "欢迎使用微大学！")
  end

  def common_email(to_mail,vmail_id)
  	@vmail = Vmail.find(vmail_id)
    mail(:to => to_mail, :subject => @vmail.title)
  end
end
