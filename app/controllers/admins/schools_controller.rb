#encoding : utf-8
class Admins::SchoolsController < AdminsController
  def index
    @schools = School.order("id desc").paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @school = School.find(params[:id]) unless params[:id].nil?
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
     if  @school && @school.update_attributes(params[:school])
         flash[:success] = "编号为#{@school.id}的学校修改成功"
         redirect_to admins_school_path(@school)
    else
         flash[:error] = @school.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
         redirect_to edit_admins_school_path(@school)
    end
  end

  def new
    @school = School.new
  end

  def destroy
    school = School.find(params[:id])
    flash[:seccess] = "#{school.name}已删除!" if school.destroy
    redirect_to admins_schools_path
  end

  def create
    school = School.create(params[:school])
    flash[:seccess] = "#{school.name}创建成功 " if school
    redirect_to admins_schools_path
  end
end