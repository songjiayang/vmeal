#encoding : utf-8
class Admins::OrdersController < AdminsController
  def index
    time = Time.now.to_date
    unless params[:type].nil?
      if params[:type].to_i == 1 then
        time = Time.parse(params[:order_time].to_s).to_date
      end
    end
    @orders = Order.where("created_at > '#{time.to_s}' and created_at < '#{(time + 1.day).to_date.to_s}'").order("created_at desc").paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @order = Order.find(params[:id]) unless params[:id].nil?
  end
end