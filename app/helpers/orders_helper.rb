module OrdersHelper
  
  def parse_time(value,type=1)
    if type==1
      return time_tag = Time.gm(
      value["created_at(1i)"],
      value["created_at(2i)"].to_i,
      value["created_at(3i)"].to_i,
      value["created_at(4i)"].to_i,
      value["created_at(5i)"].to_i,
      value["created_at(6i)"].to_i)
    else
      return time_tag = Time.gm(value["updated_at(1i)"].to_i,
      value["updated_at(2i)"].to_i,
      value["updated_at(3i)"],
      value["updated_at(4i)"].to_i,
      value["updated_at(5i)"].to_i,
      value["updated_at(6i)"].to_i)
    end

  end
end
