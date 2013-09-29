#encoding:utf-8

class Application < ActiveRecord::Base
  
  APPLICATION_STATUS =['未处理','正在处理中','处理完毕','申请无效']
  belongs_to :user
  
  def translate_status_to_s
      case status
        when 0 then "未处理"
        when 1 then "正在处理中"
        when 2 then "处理完毕"
        when 3 then "申请无效"
        else "正在处理中"
      end
  end
  
  def self.modify_staus(status)
    case status
      when "未处理" then 0
      when "正在处理中" then 1
      when "处理完毕" then 2
      when "申请无效" then 3
        else 1
      end
  end
  
  def self.do_validate(value)
    str = /^[0-9]{11}+$/
    error = {}
    if str.match(value[:tel]).nil?
      error[:tel] = "请检查电话号码是否合法"
    end
    if value[:user_name]==""
      error[:user_name] = "用户姓名不能为空"
    end
    if  value[:store_name]==""
      error[:store_name] = "店铺名称不能为空"
    end
    if value[:address]==""
      error[:address] = "店家地址不能为空"
    end
    
    if  value[:about_store]==""
      error[:about_store] = "店家说明不能为空"
    end
    
    if error.keys.size>0
      return error
    else
      return nil
    end
  
  end
end
