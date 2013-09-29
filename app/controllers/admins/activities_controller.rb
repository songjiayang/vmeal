#encoding : utf-8
class Admins::ActivitiesController < AdminsController

  def index
    @activities = Activity.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
  end

  def new
  	@activity = Activity.new
  end

  def create
  	 @activity = Activity.new(params[:activity])
     if @activity.save
         flash[:success] = "编号为#{@activity.id}的活动创建成功"
         redirect_to admins_activity_path(@activity)
     else
         flash[:error] = @activity.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
         redirect_to new_admins_activity_path
     end
  end

  def show
  	@activity = Activity.find(params[:id])
  end

  def edit
  	@activity = Activity.find(params[:id])
  end


  def destroy
     	@activity = Activity.find(params[:id])
     	if  @activity && @activity.destroy
     	 	flash[:success] = "编号为#{@activity.id}删除成功."
     	else
           flash[:error] = "编号为#{@activity.id}删除不成功."
     	end
     	redirect_to admins_activities_path
  end


  def update
      @activity = Activity.find(params[:id])
      if @activity && @activity.update_attributes(params[:activity])
           flash[:success] = "编号为#{@activity.id}的广告修改成功"
            redirect_to admins_activity_path(@activity)
      else
            flash[:error] = @activity.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
            redirect_to edit_admins_activity_path(@activity)
      end
  end

  def kaijiang
  	@activity = Activity.find(params[:id].to_i)
  	@user_ids = @activity.score_historiess.map{|e|e.user_id}
  	uniq_users = @user_ids.uniq
  	index_users = []
  	if uniq_users.size > @activity.total_number
  			while(index_users.size < @activity.total_number )
  				id = @user_ids.sample(1)[0]
  				unless index_users.index id
  					index_users << id
  				end
  			end
  	else
  		index_users = uniq_users
  	end
    index_users.each  do |user_id| 
      ActivitiesUsers.create({user_id:user_id,activity_id:@activity.id})
    end 
  	render json: index_users.size
  end

end