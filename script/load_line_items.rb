LineItem.transaction do
  (1..10).each do |i|
    LineItem.create(
        :food_id =>i%1000+1 ,
        :quantity =>10,
        :order_id =>i%10+1,
        :created_at =>Time.now,
        :updated_at =>Time.now
      )
  end
end

 
