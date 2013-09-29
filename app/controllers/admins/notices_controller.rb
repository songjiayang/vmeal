#encoding : utf-8
class Admins::NoticesController < AdminsController

     def index
       @notices = Notice.order("updated_at desc").paginate(:page => params[:page], :per_page => 20)
     end

     def new
     	 @notice = Notice.new
     end

     def create
     	  @notice = Notice.new(params[:notice])
        if @notice.save
            flash[:success] = "编号为#{@notice.id}的广告创建成功"
            redirect_to admins_notice_path(@notice)
        else
            flash[:error] = @notice.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
            redirect_to new_admins_ad_path
        end
     end

     def show
     	  @notice = Notice.find(params[:id])
     end

     def destroy
     	 @notice = Notice.find(params[:id])
     	 if  @notice && @notice.destroy
     	 	flash[:success] = "编号为#{@notice.id}删除成功."
     	 else
           flash[:error] = "编号为#{@notice.id}删除不成功."
     	 end
     	 redirect_to admins_notices_path
     	
     end

     def update
	     	@notice = Notice.find(params[:id].to_i)
	      if  @notice && @notice.update_attributes(params[:notice])
	           flash[:success] = "编号为#{@notice.id}的广告修改成功"
	            redirect_to admins_notice_path(@notice)
	      else
	            flash[:error] = @notice.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
	            redirect_to edit_admins_notice_path(@notice)
	      end
     end

     def edit
     	  @notice = Notice.find(params[:id])
     end

end
