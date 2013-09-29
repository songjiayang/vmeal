#encoding : utf-8
module StoresHelper
  
  def string_to_a_format_number(s1,n)
      s1 = s1.to_f.round(n) if s1.to_f.to_s ==s1.to_s
      s1
  end
  
  def follow_store(store)
    unless current_user.stores.include?(store)
      raw("<a id='store-fllow' href='javascript:void(0)' onclick='follow_store(#{store.id})'>#{@favoritec_count}</a><p>喜欢就收藏我：</p>")
    else
      raw("<a id='store-unfllow' href='javascript:void(0)' onclick='cancel_follow_store(#{store.id})'>#{@favoritec_count}</a><p>点击取消收藏：</p>")
    end
  end
end
