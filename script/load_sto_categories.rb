StoCategory.transaction do
    StoCategory.create(
      :name => "中餐",
      :created_at =>Time.now,
      :updated_at =>Time.now
      )
      
     StoCategory.create(
      :name => "火锅",
      :created_at =>Time.now,
      :updated_at =>Time.now
      )
      
     StoCategory.create(
      :name => "西餐",
      :created_at =>Time.now,
      :updated_at =>Time.now
      )
      
    StoCategory.create(
      :name => "冷饮",
      :created_at =>Time.now,
      :updated_at =>Time.now
      )
end
