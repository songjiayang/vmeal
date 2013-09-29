class ActivitiesController < ApplicationController

  def index
  	@type = params[:type].to_s
  	now_time = Time.now
  	if @type=="coming"
  		@activites = Activity.where("start_time > '#{now_time}'").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  	elsif  @type== ""
  		 @activites = Activity.where("start_time < '#{now_time}' and end_time > '#{now_time}'").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  	else
  		@activites = Activity.where("end_time < '#{now_time}'").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  	end
    @index_activity = ActivitiesUsers.order("created_at desc").limit(4);
  	render :layout=>"choujiang"
  end

  def show
  	@activity = Activity.find(params[:id].to_i)
    @hot_activity = Activity.order("join_number desc").limit(3)
  	now_time = Time.now
  	if (@activity.start_time > now_time)
  	    @type = 1
  	elsif (now_time>@activity.start_time and now_time < @activity.end_time) 
  			@type = 2
    else
    	  @type = 4
    end
  	render :layout=>"choujiang"
  end
  
end
