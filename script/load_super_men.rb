SuperMan.transaction do
    SuperMan.create(
    :user_name => "songjiayang",
    :password =>"weidaxue",
    :user_type =>1,
    :created_at =>Time.now,
    :updated_at =>Time.now
      )

end