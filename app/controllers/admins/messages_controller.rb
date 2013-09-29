#encoding : utf-8

class Admins::MessagesController < AdminsController

     def index
         if params[:q]
          @messages = Message.where(:is_locked=> params[:q].to_i).order("created_at desc").paginate(:page => params[:page], :per_page => 20) 
          status = (params[:q]=="0"? "未屏蔽":"已屏蔽")
          flash[:success] ="查询#{status}留言结果"
          else
            @messages = Message.order("created_at desc").paginate(:page => params[:page], :per_page => 20)    
          end
     end

     def is_locked
         @message = Message.find(params[:id])
         result = "error"
         if @message
             if params[:type]== "1"
                @message.is_locked = 1
             elsif params[:type]=="0"
                @message.is_locked = 0
             end
             result="0"  if @message.save
         end
         render json: result
     end

     def query
          redirect_to "/admins/messages?q=#{params[:is_clocked].to_s}"
     end


end
