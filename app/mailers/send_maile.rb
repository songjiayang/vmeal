#encoding : utf-8
class SendMaile < ActionMailer::Base
  
  default from: "service@weidaxue.me"
  def send_email(user_address,title)
    if user_address
        mail(:to => user_address, :subject => title.nil? ? "欢迎来到我的网站":title).deliver
    end
  end
end
