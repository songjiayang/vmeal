#encoding:utf-8

class FsManagerController < ApplicationController
  
   before_filter :is_super_men?
  
  def index
    @food_senters = FoodSenter.page(params[:page]).per(5)
  end

  def show
    @food_senter = FoodSenter.find(params[:id])
  end

  def new
    @food_senter = FoodSenter.new
  end

  def edit
    @food_senter = FoodSenter.find(params[:id])
  end

  def create
    params[:food_senter][:user_type] = FoodSenter.translate_type_i( params[:food_senter][:user_type])
    @food_senter = FoodSenter.new(params[:food_senter])
    respond_to do |format|
      if @food_senter.save
        format.html { redirect_to  fs_manager_index_path(@food_senter), notice: "编号为#{@food_senter.id}的配送人员创建成功！" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /food_senters/1
  # PUT /food_senters/1.json
  def update
    @food_senter = FoodSenter.find(params[:id])

    respond_to do |format|
      if @food_senter.update_attributes(params[:food_senter])
        format.html { redirect_to admin_food_senter_path(@food_senter), notice: "编号为#{@food_senter.id}的配送人员修改成功！" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @food_senter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy1
    @food_senter = FoodSenter.find(params[:id])
    @food_senter.destroy
    redirect_to fs_manager_index_path , notice: "编号为#{@food_senter.id}的配送人员已删除！"
  end
  
  def change_status
     @food_senter = FoodSenter.find(params[:id])
     @food_senter.is_work = @food_senter.change_status
     @food_senter.save
     redirect_to fs_manager_index_path(@food_senter), notice: "编号为#{@food_senter.id}的配送人员修改成功！"
  end
  
   private 
   def is_super_men?
    if session[:super_men].nil?
      redirect_to login_super_men_path  ,notice:"小贼，休想逃过我的检查"
    end
  end
end
