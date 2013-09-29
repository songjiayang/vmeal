module ApplicationHelper
  def my_time_parser(time)
    DateTime.parse(time.to_s).strftime('%Y-%m-%d %H:%M:%S').to_s
  end

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def tags_to_image_array(tags)
    tags = tags.split(/,/)
    tag_image_urls = []
    tag_rml = HomeYaml.getYaml('config/tags.yml')
    tags.each do |tag|
      tag_image_urls<<tag_rml['tags'][tag]
    end
    tag_image_urls
  end

  def shoping_car
    carts = []
    if session[:carts_id].nil? || session[:carts_id].size==0
      session[:carts_id] = []
    else
      begin
        session[:carts_id].each do |cart_id|
          carts << Cart.find(cart_id)
        end
      rescue ActiveRecord::RecordNotFound
      carts =[]
      end
    end
    carts
  end

  def get_total_price
    total_price=0
    if !shoping_car.nil?
      shoping_car.each do |car|
        total_price=total_price+car.total_price
      end
    end

    return total_price
  end

  def is_time_eat_food?
    return (Time.parse('11:30:00')<Time.now  && Time.now<Time.parse('13:30:00'))|| (Time.parse('17:30:00')<Time.now && Time.now<Time.parse('19:30:00'))
  end

end
