#encoding : utf-8
class Admins::StoresController < AdminsController
  def show
    @store= Store.find(params[:id])
  end

  def index
    @default_store = Store.where(:name => "微大学虚拟餐厅").first
    if params["query"] == "" || params["query"].nil?
      @stores = Store.paginate(:page => params[:page], :per_page => 10)
    else
      @stores = Store.where(" name LIKE ?","%#{params["query"]}%").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store= Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:success] = "店家信息更新成功"
      redirect_to "/admins/stores/"+@store.id.to_s
    else
      flash[:error] = "店家信息更新失败"
      redirect_to "/admins/stores/"+@store.id.to_s+"/edit"
    end
  end

  def new
    @store = Store.new
  end

  def create
    if params[:store][:name].nil? || params[:store][:name] == ""
      flash[:error] = "请填写店名才可以新开店"
      redirect_to "/admins/stores/new"
    else
      @store = Store.new
      @default_store = get_defalut_store
      @store.name = params[:store][:name]
      @store.introduce = @default_store.introduce
      @store.address = @default_store.address
      @store.tags = @default_store.tags
      @store.categore = @default_store.categore
      @store.tel = @default_store.tel
      @store.send_price = @default_store.send_price
      @store.rank = @default_store.rank
      @store.opentime = @default_store.opentime
      @store.closetime = @default_store.closetime
      if @store.save!
        flash[:success] = "新开店家成功"
        redirect_to "/admins/stores"
      else
        flash[:error] = "新开店家失败"
        redirect_to "/admins/stores/new"
      end
    end
  end

  private

  def get_defalut_store
    if Store.where(:name => "微大学虚拟餐厅").size == 0
      Store.create_default_store
    else
      Store.where(:name => "微大学虚拟餐厅").first
    end
  end

end
