#encoding : utf-8
task :send_maile => :environment do
	users = User.where("id > 30")
	users.each do |user|
     SendMaile.send_email(user.email,"微大学祝大家圣诞节快乐").deliver
	end
end
