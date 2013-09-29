#encoding : utf-8

class Admins::UsersController < AdminsController

     def index
     	 type = params[:type].to_i
       if type == 0
       		@users =  User.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
       elsif type == 1
       	  @users =  User.where("is_locked =1").order("created_at desc").paginate(:page => params[:page], :per_page => 20)
       elsif type == 3
          @users =  User.order("integral desc").paginate(:page => params[:page], :per_page => 20)
       else
       	  @users =  User.where("is_locked =0").order("created_at desc").paginate(:page => params[:page], :per_page => 20)
       end
       @page = (params[:page].to_i==0? 1: params[:page].to_i)
     end

     def query
     	 if params[:type] == "email"
     	     @users =  User.where("email like ? ",'%'+params[:query]+'%').order("created_at desc").paginate(:page => params[:page], :per_page => 20)
     	 else 
     	 	   @users =  User.where("username like ? ",'%'+params[:query]+'%').order("created_at desc").paginate(:page => params[:page], :per_page => 20)
     	 end
     end

     def destroy
     	 @user = User.find(params[:id])
     	 if  @user && @user.destroy
     	 	   flash[:success] = "#{@user.username}删除成功."
     	 else
           flash[:error] = "系统原因导致操作不成功."
     	 end
     	 redirect_to admins_users_path
     end

     def is_locked
     	  @user = User.find(params[:user_id])
     	  type = (@user.is_locked==0? "锁定": "解锁")
     	 if  @user && @user.update_attributes({:is_locked=>(@user.is_locked-1).abs})
     	 	   flash[:success] = "账户#{@user.username}#{type}成功."
     	 else
           flash[:error] = "账户#{@user.username}#{type}不成功."
     	 end
     	  redirect_to admins_users_path(:page=>params[:page])
     end

     def history
     	
     end

     def export
     	
     end

     def do_export
     	   unless (params[:export].blank? || params[:export][:users].blank?)
     	   	  user_data_attr = params[:export][:users].keys
     	   	  select_str = user_data_attr.join(",").to_s
     	   	  all_user = User.select(select_str)
     	   	  header_hash ={"id"=>"编号","username"=>"用户名","email"=>"邮箱","created_at"=>"创建时间","is_locked"=>"状态"}
     	   	  header= []
     	   	  user_data_attr.each {|k| header << header_hash[k.to_s]}
     	      csv_helper({:header=>header,:values=>all_user.map{|e|e.instance_values["attributes"].values}})
     	   else
     	   	 redirect_to export_admins_users_path
     	   end
     end

     def show
        @user = User.find(params[:id])
         
     end


end
