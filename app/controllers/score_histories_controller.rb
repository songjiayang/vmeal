class ScoreHistoriesController < ApplicationController
  
  before_filter :verify_user_login_permission

  def new
    if current_user.good_address
    	@activity = Activity.find(params[:id].to_i)
    	@sh = ScoreHistories.new
    	render :layout=>"choujiang"
    else
      flash[:error_type] = 1
      redirect_to "/cj/error"
    end
  end

  def create
     @activity = Activity.find(params[:activity_id].to_i)
     if @activity.need_score > current_user.integral
        flash[:need_score] = @activity.need_score
        flash[:error_type] = 2
        redirect_to "/cj/error"
     else
       @sh = ScoreHistories.new
       @sh.user_id = current_user.id
       @sh.change_type = 3
       @sh.activity_id = params[:activity_id]
       @sh.change_score = (0-@activity.need_score)
       @activity.join_number += 1
       @activity.save
       if @sh.save
          current_user.integral+=@sh.change_score
          resutl = current_user.save
          puts current_user.integral
          puts current_user.id
          redirect_to "/users/score_histories"
       end
     end     
  end

   def error
    @need_score = flash[:need_score]
    @error_type = flash[:error_type]
    render :layout=>"choujiang"
  end

end
