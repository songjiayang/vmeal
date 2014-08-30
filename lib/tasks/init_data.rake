namespace :init do 
	desc "初始化活动数据"
	task :init_activities => :environment do
		 10.times {Activity.create({description:"hello",
		              end_time:(Time.now+3.day),
		              need_score:10, 
		              real_money:30.5, 
		              title:"☆女人节专场★大号抱抱熊",
		              total_number:1,
		              start_time:Time.now})}
		  10.times {Activity.create({description:"hello",
		              end_time:(Time.now+3.day),
		              need_score:10, 
		              real_money:30.5, 
		              title:"☆女人节专场★大号抱抱熊",
		              total_number:1,
		              start_time:(Time.now+1.day)})}
		  10.times {Activity.create({description:"hello",
		              end_time:(Time.now),
		              need_score:10, 
		              real_money:30.5, 
		              title:"☆女人节专场★大号抱抱熊",
		              total_number:1,
		              start_time:(1.day.ago)})}
	end

	desc " 赠送所有用户100积分"
	task :init_integral => :environment do
		  User.all.each do |user|
		  		user.integral =10
		  		user.save
		  end
	end

	desc " 清除所有抽奖记录"
	task :clear_some_thing => :environment do
		  ScoreHistories.destroy_all
		  ActivitiesUsers.destroy_all
		  Activity.update_all({:join_number=>0})
	end

	desc "初始化学校数据"
	task :init_schools => :environment do
				%w(西南石油大学（新都校区） 四川音乐学院（新都校区）).each{|n| School.create({name:n})}
				Store.update_all({school_id:School.first.id})
	end
end