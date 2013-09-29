#encoding : utf-8
require 'net/http'
require 'uri'
module MobileShortMessage


  Url_Params_Sn_Password = "?cdkey=#{CONFIG["ymrt_key"]}&password=#{CONFIG["ymrt_password"]}"
  Function_Url_Account_Info = "http://sdkhttp.eucp.b2m.cn/sdkproxy/querybalance.action#{Url_Params_Sn_Password}"
  Function_Url_Send_Message = "http://sdkhttp.eucp.b2m.cn/sdkproxy/sendsms.action#{Url_Params_Sn_Password}"
  Regexp_Phone_Number = /^(?:13|14|15|18)[0-9]{9}$/
  Size_Per_Message = 500 - 7 #默认的短信长度
  Message_SEND_TIME_OUT_SECONDS = 30
  Message_tail = "【微大学】"


  def send_message(phone_numbers, content)
     should_send_phone_numbers,content = format_phone_numbers_and_content(phone_numbers,content)
     do_send(should_send_phone_numbers,content) unless should_send_phone_numbers.blank?
  end

  def account_info
    Net::HTTP.get(URI.parse(Function_Url_Account_Info))
  end

  private
  def is_a_phone_number?(phone_number)
      phone_number =~ Regexp_Phone_Number
  end

  def format_phone_numbers_and_content(phone_numbers, content)
     should_send_phone_numbers = []
     if phone_numbers.is_a?(Array)
       should_send_phone_numbers += phone_numbers.select { |e| is_a_phone_number? e.to_s }
     else
       should_send_phone_numbers << phone_numbers if (is_a_phone_number? phone_numbers)
     end
     return should_send_phone_numbers,content.to_s.strip.first(Size_Per_Message)+Message_tail
  end

  def do_send(should_send_phone_numbers,content)
    should_send_phone_numbers.each do |phone_number|
      begin
        Timeout::timeout(Message_SEND_TIME_OUT_SECONDS) do
          url ="#{Function_Url_Send_Message}&phone=#{URI.encode(phone_number.to_s)}&message=#{URI.encode(content)}"
          Net::HTTP.get URI.parse(url)
          Rails.logger.info "向手机号#{phone_number},发送#{content}成功!"
        end
      rescue Exception => e
        Rails.logger.error("#{e.to_s}导致向手机号#{phone_number}发送短信失败.")
      end
    end
  end
end
