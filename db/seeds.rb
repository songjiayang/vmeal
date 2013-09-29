#encoding : utf-8
School.destroy_all
School.create({:name=>'西南石油大学', :short_name=>'swpu'})


Store.destroy_all
Store.create_default_store
StoreUser.destroy_all
StoreUser.create({:username =>"store_user", :store_id => Store.last.id, :password=>'test123'})


Admin.destroy_all
Admin.create({:name => 'admin_test', :password=>'test123', :password_confirmation=>"test123", :role =>1 })



Category.destroy_all
%w(Category1 Category2).each do |name|
	Category.create({:name=>name, :store=>Store.first})
end


Food.destroy_all
Category.all.each do |category|
	Food.create({:name=>"Food#{category.id}", :store => category.store, :category => category, :price => 10.5, :sum => 100, :energy=> 100})
end





