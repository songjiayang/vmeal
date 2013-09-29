# encoding: utf-8
class Admins::StoreUsersController < AdminsController
  #before_filter :is_admin_login?
  # GET /store_users
  # GET /store_users.json
  def index
    @store_users = StoreUser.all
  end

  # GET /store_users/new
  # GET /store_users/new.json
  def new
    @store_user = StoreUser.new
    @stores = Store.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store_user }
    end
  end

  # GET /store_users/1/edit
  def edit
    @store_user = StoreUser.find(params[:id])
    @stores = Store.all
  end

  # POST /store_users
  # POST /store_users.json
  def create
    @store_user = StoreUser.new(params[:store_user])
    if @store_user.save
      flash[:success] = "编号为#{@store_user.id}店家创建成功"
      redirect_to "/admins/store_users/"
    else
      flash[:error] = "编号为#{@store_user.id}店家创建失败"
      redirect_to "/admins/store_users/new"
    end
  end

  # PUT /store_users/1
  # PUT /store_users/1.json
  def update
    @store_user = StoreUser.find(params[:id])
    if @store_user.update_attributes(params[:store_user])
      flash[:success] = "编号为#{@store_user.id}店家更新成功"
      redirect_to "/admins/store_users/"
    else
      flash[:error] = "编号为#{@store_user.id}店家更新失败"
      redirect_to "/admins/store_users/"+params[:id].to_s+"/edit"
    end
  end

  # DELETE /store_users/1
  # DELETE /store_users/1.json
  def destroy
    @store_user = StoreUser.find(params[:id])
    if @store_user.destroy
      flash[:success] = "编号为#{@store_user.id}店家删除成功"
    else
      flash[:error] = "编号为#{@store_user.id}店家删除失败"
    end
     redirect_to "/admins/store_users/"
  end

  private

  def is_admin_login?
    if session[:admin].nil?
      flash[:error] = "请先登录"
      redirect_to login_admins_path
    end
  end
end
