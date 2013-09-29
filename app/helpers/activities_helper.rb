module ActivitiesHelper
	def parse_type_to_nav_class(type)
		if type==""
		   "1"
		elsif type=="coming"
			 "2"
		else
			 "3"
		end
	end

	def parse_type_to_deal_class(type)
		if type==""
		   "2"
		elsif type=="coming"
			 "1"
		else
			 "4"
		end
	end


	def parse_time_for_activity(seconds)
		result = []
		result << seconds/86400
		seconds = seconds%86400
		result << seconds/3600
		seconds = seconds%3600
		result << seconds/60
		result << seconds%60
		result.map { |e| e < 10 ? "0#{e.to_s}": e.to_s }
	end
end
