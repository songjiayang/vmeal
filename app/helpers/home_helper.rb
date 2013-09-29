module HomeHelper
  
 def get_store_open_time(store)
    "#{store.opentime.strftime '%H:%M'}-#{store.closetime.strftime '%H:%M'}"
 end

 def format_notice(notices)
 	raw notices.map{|notice|"\"<a href='/notices/#{notice.id}'>#{notice.title}</a>\""}.join(",")
 end
end
