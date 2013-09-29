# encoding: utf-8
class FoodsController < ApplicationController

  #规定必须登录才可以进行店家分类的相关操作
  before_filter  :validate_store_is_login_in, :except => [:search]
  # GET /foods/new
  # GET /foods/new.json
  def new
    @food = Food.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  def show
    @food = Food.find(params[:id])
    render json: @food
  end

  # GET /foods/1/edit
  def edit
    @food = Food.find(params[:id])
    @category = @food.category
  end

  # POST /foods
  # POST /foods.json
  def create
    category = Category.find(Category.get_category_id_by_name(session[:store_id],params[:food][:category_id]))
    params[:food][:category_id] =  category.id
    params[:food][:rank]=4.5
    @food = Food.new(params[:food])
    @food.store_id = session[:store_id]
    respond_to do |format|
      if @food.save
        flash[:create_food_info] = "成功添加#{@food.name}!"
      else
        flash[:create_food_info] = "由于某种原因导致添加餐品失败"
      end
      format.html { redirect_to "/stores/edit/foods" }
    end
  end

  # PUT /foods/1
  # PUT /foods/1.json
  def update
    @food = Food.find(params[:foodid])
    category = Category.find(Category.get_category_id_by_name(session[:store_id],params[:food][:category_id]))
    params[:food][:category_id] =  category.id
    respond_to do |format|
      if @food.update_attributes(params[:food])
        flash[:create_food_info] = "更新#{@food.name}成功!"
        format.html { redirect_to "/stores/edit/foods" }
        format.json { head :no_content }
      else
        flash[:create_food_info] = "更新#{@food.name}失败，请查找原因!"
        format.html { redirect_to "/stores/edit/foods" }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def add_recomment
     @food = Food.find(params[:recomment_food_id])
     if @food.update_attributes(params[:food])
         flash[:create_food_info] = "推荐#{@food.name}成功!"
         redirect_to "/stores/edit/foods" 
     else
       flash[:create_food_info] = "推荐#{@food.name}失败!"
       redirect_to "/stores/edit/foods"
     end
     
  end

  def search
    per_page = 5
    @key_word = params[:keys]
    @foods= @key_word.blank?? []: Food.foods_name_like(params[:keys])
    @search_foods=@foods.group_by{|s| s.store_id}
    @page_number = params[:page].nil? ? 1 : params[:page].to_i
    @max_page = (@search_foods.size+per_page-1)/per_page
    if  @search_foods.size < 1
      @page_number = 1
    elsif @page_number >  @max_page
      @page_number =   @max_page
    end
    index = (@page_number-1)*per_page
    @show_stores = @search_foods.to_a[index..index+per_page-1]
    @carts = Cart.find_my_cart(cart_id.to_s)
  end

  private

  #判断一个用户是否是店家
  #如果是店家的话可以进行相关的操作，如果不是店家的话不可以进行店家的操作
  def validate_store_is_login_in
    if session[:store_id].nil?
      redirect_to login_stores_path(:notice => "请先登录")
    end
  end
end
