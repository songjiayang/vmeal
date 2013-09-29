#encoding:utf-8
class ComplaintsController < ApplicationController
  before_filter :authenticate_user!
  def  do_complaint
    
    @order = Order.where("order_number = ?",params[:complaint][:order_number]).first
    if @order.is_complainted ==1
      redirect_to  user_complaints_users_path   ,notice:"已经投诉过了订单编号为#{@order.order_number},不能再投诉了"
    else
        @complaint = Complaint.new(params[:complaint])
        @complaint.user_id = current_user.id
        @complaint.save
        @order.is_complainted = 1
        @order.save
        redirect_to  user_complaints_users_path   ,notice:"投诉成功!"
    end
  end

end