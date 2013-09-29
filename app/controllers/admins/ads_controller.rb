#encoding : utf-8

class Admins::AdsController < AdminsController

     def index
       @ads =  Ads.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
       @page = (params[:page].to_i==0? 1: params[:page].to_i)
     end

     def show
        @ad = Ads.find(params[:id])
     end

     def new
        @ad = Ads.new
     end

     def edit
        @ad = Ads.find(params[:id])
     end

     def create
        @ad = Ads.new(params[:ads])
        if @ad.save
            flash[:success] = "编号为#{@ad.id}的广告创建成功"
            redirect_to admins_ad_path(@ad)
        else
            flash[:error] = @ad.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
            redirect_to new_admins_ad_path
        end
         
     end

     def destroy
     	 @ad = Ads.find(params[:id])
     	 if  @ad && @ad.destroy
     	 	flash[:success] = "编号为#{@ad.id}删除成功."
     	 else
           flash[:error] = "编号为#{@ad.id}删除不成功."
     	 end
     	 redirect_to admins_ads_path
     end

     def update
        @ad = Ads.find(params[:id])
        if  @ad && @ad.update_attributes(params[:ads])
           flash[:success] = "编号为#{@ad.id}的广告修改成功"
            redirect_to admins_ad_path(@ad)
        else
            flash[:error] = @ad.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
            redirect_to edit_admins_ad_path(@ad)
        end
         
     end

     def is_locked
     	 @ad = Ads.find(params[:ad_id])
     	 if  @ad && @ad.update_attributes({:status=>(@ad.status=="使用中"? "已下架":"使用中")})
     	 	 flash[:success] = "编号为#{@ad.id}状态改变成功."
     	 else
           flash[:error] = "编号为#{@ad.id}状态改变不成功"
     	 end
     	  redirect_to admins_ads_path(:page=>params[:page])
     end

    def query
         if params[:type] == "status"
             @ads =  Ads.where("status like ? ",'%'+params[:query]+'%').order("created_at desc").paginate(:page => params[:page], :per_page => 20)
         elsif !params[:query].blank? and "焦点图".include? params[:query].to_s
            @ads =  Ads.where("ad_type =1").order("created_at desc").paginate(:page => params[:page], :per_page => 20)
         elsif !params[:query].blank? and "一般图片".include? params[:query].to_s
            @ads =  Ads.where("ad_type =2").order("created_at desc").paginate(:page => params[:page], :per_page => 20)
         else
            @ads = Ads.where("ad_type =3").order("created_at desc").paginate(:page => params[:page], :per_page => 20)
         end
     end


end
