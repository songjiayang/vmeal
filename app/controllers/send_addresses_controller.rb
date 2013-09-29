#encoding = utf-8
class SendAddressesController < ApplicationController

  before_filter :verify_user_login_permission
  # GET /send_addresses/new
  # GET /send_addresses/new.json
  def new
    @send_address = SendAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @send_address }
    end
  end

  # GET /send_addresses/1/edit
  def edit
    begin
      @send_address = SendAddress.find(params[:id])
      if @send_address.user_id == current_user.id
        else
        redirect_to person_center_address_users_path
        flash[:notice] = '不可以非法修改别人的地址！！'
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to person_center_address_users_path
      flash[:notice] = '不存在你需要修改的地址'
    end
  end

  # PUT /send_addresses/1
  # PUT /send_addresses/1.json
  def update
    @send_address = SendAddress.find(params[:id])
    if  @send_address.update_attributes(params[:send_address])
      redirect_to person_center_address_users_path
      flash[:notice] = '地址更新成功'
    else
      render action: "edit"
    end
  end
end
