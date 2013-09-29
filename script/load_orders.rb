
Order.transaction do
  (1..10).each do |i|
    Order.create(
        :address =>"西南石油大学学生公寓",
        :phone =>"18981974880",
        :name =>"学生#{i}",
        :order_number =>"orders",
        :pay_type => "货到付款",
        :comment => "速度快点阿亲",
        :user_id =>1,
        :created_at =>"2001-07-27 03:28:19",
        :updated_at =>"2001-07-27 03:28:19"
      )
  end
end

 
