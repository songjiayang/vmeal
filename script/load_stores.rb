Store.transaction do
    Store.create(
       :name => "冰岛の恋",
       :introduce =>"干净好吃，快捷方便",
       :address =>"西南石油大学",
       :opentime => "2012-07-27  7:30:00",
       :closetime => "2012-07-27  23:00:00",
       :tags => "直销，免快递费",
       :categore => "冷饮",
       :tel =>"8888888",
       :is_super_market =>0,
       :isclose => 0 ,
       :send_price => 0,
       :rank => 4.5,
       :settledtime => Time.now,
       :image_url_file_name => "store.jpg",
       :created_at => Time.now,
       :updated_at => Time.now
     )     
end
