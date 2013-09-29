#encoding:utf-8

module AdminsHelper

	def titles(data)
		[ "本周有#{data[1]}位新注册用户.",
		  "今日有#{data[3]}个新订单." ,
		  "有#{data[5]}个平台投诉待回复.",
		  "有#{data[7]}个新留言待确认."
		]
	end

	def icons
     [ "icon32 icon-red icon-user ",
     	  "icon32 icon-color icon-home",
     	  "icon32 icon-red icon-home",
     	  "icon32 icon-red icon-comment"
      ]
	end

	def subjects
		[ "平台用户","昨日订单","平台投诉","店家留言"]
	end

	def colors
		["blue","green","yellow","red"]
	end
  
	def format(datetime)
		datetime.strftime("%Y/%m/%d")
	end

	def select_pages
		  [25,50,75,100].map{|count|"<option>#{count}</option>"}.join.html_safe
	end

end
