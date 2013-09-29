#encoding:utf-8
class SuperMenController < ApplicationController

  before_filter :is_super_men?, :except => [:do_login,:login]
  
  def index
    @super_men = SuperMan.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @super_men }
    end
  end

  def show
    @super_man = SuperMan.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @super_man }
    end
  end

  def new
    @super_man = SuperMan.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @super_man }
    end
  end

  def edit
    @super_man = SuperMan.find(params[:id])
  end

  def create
    @super_man = SuperMan.new(params[:super_man])
    respond_to do |format|
      if @super_man.save
        format.html { redirect_to @super_man, notice: 'Super man was successfully created.' }
        format.json { render json: @super_man, status: :created, location: @super_man }
      else
        format.html { render action: "new" }
        format.json { render json: @super_man.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @super_man = SuperMan.find(params[:id])
    params[:super_man][:user_type] = SuperMan.translate_type_i(params[:super_man][:user_type])
    respond_to do |format|
      if @super_man.update_attributes(params[:super_man])
        format.html { redirect_to  maintains_super_men_path }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @super_man = SuperMan.find(params[:id])
    @super_man.destroy
    respond_to do |format|
      format.html { redirect_to super_men_url }
      format.json { head :no_content }
    end
  end

  def super_managers
    @managers = SuperMan.all_super_managers
  end
  
  def complaint_return
    session[:complaint_id]=params[:id]
  end
  
  def complaint_new
    @complaint_reply = ComplaintReply.new(params[:complaint])
    @complaint_reply.super_man_id = session[:super_men][:user_id]
    @complaint_reply.complaint_id =  session[:complaint_id]
    if @complaint_reply.save
       complaint = Complaint.find(@complaint_reply.complaint_id)
       complaint.has_replied = 1
       complaint.save
       redirect_to all_complains_super_men_path   ,notice:"编号为#{complaint.order_number}的投诉已回复"
    end
      
  end

  def maintains
    @managers = SuperMan.all_maintains
  end

  def do_login
    @magnager = SuperMan.is_presence?(params[:name],params[:password])
    unless @magnager.nil?
      super_man = {}
      super_man[:user_name] = params[:name]
      super_man[:user_type] = @magnager.user_type
      super_man[:user_id] = @magnager.id
      session[:super_men] = super_man
      redirect_to super_men_path
    else
      redirect_to login_super_men_path , notice:"用户名或密码错误！"
    end
  end
  
  def all_complains
     @complains = Complaint.where("has_replied is null").all
  end

  def login_out
    session[:super_men] = nil
    redirect_to login_super_men_path ,notice:"工作愉快o =>亲！"
  end

  private
  
  def is_super_men?
    if session[:super_men].nil?
      redirect_to login_super_men_path
      return 
    end
    unless session[:super_men][:user_type] == 1
      redirect_to super_men_path
    end
  end

end
