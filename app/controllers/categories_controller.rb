# encoding: utf-8
class CategoriesController < ApplicationController

  #规定必须登录才可以进行店家分类的相关操作
  before_filter :is_my_store?
  # GET /categories/new
  # GET /categories/new.json
  def new
    session[:sid] = params[:store_id]
    @category = Category.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end

  def show
    @category = Category.find(params[:id])
    render json:@category
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @store = @category.store
  end

  # POST /categories
  # POST /categories.json
  def create
    @store = Store.find(session[:store_id])
    @category = @store.categories.new(params[:category])
    if (@category.name.nil? || @category.sortvalue.nil?)
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @category.save
          flash[:create_category_info] = "成功添加#{@category.name}!"
          format.html { redirect_to "/stores/edit/categories/" }
          format.json { render json: @category, status: :created, location: @category }
        else
          flash[:create_category_info] = "添加#{@category.name}失败!"
          format.html { redirect_to "/stores/edit/categories/" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:categoryid])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:create_category_info] = "更新#{@category.name}成功!"
        format.html { redirect_to "/stores/edit/categories/"}
        format.json { head :no_content }
      else
        flash[:create_category_info] = "更新#{@category.name}失败!"
        format.html { redirect_to "/stores/edit/categories/"}
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def is_my_store?
    if session[:store_id].nil?
      flash[:error] = "请先登录"
      redirect_to login_stores_path
    end
  end

end
