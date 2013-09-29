#encoding : utf-8
class Admins::VmailsController < AdminsController
     def index
         @mails= Vmail.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
     end

     def new
       @mail = Vmail.new
     end

     def show
       @mail = Vmail.find(params[:id])
     end

     def create
        new_one_mail
        if @mail.save
            flash[:success] = "编号为#{@mail.id}的邮件创建成功"
            redirect_to "/admins/vmails/#{@mail.id}"
        else
             flash[:error] = @mail.errors.messages.map{|k,v|k.to_s+": "+v.join(",")}.join("."+'<br/>')
            redirect_to new_admins_vmail_path
        end
     end

     def sent_now
       result = "error"
        @mail = Vmail.find(params[:id])
        mails = @mail.sent_mails
        if mails == "所有人"
            mails = User.all.map{|m|m.email}
        else
            mails = mails.split(";")
        end
        Resque.enqueue(MailSenter, mails, @mail.id)
        @mail.is_send = 1
        result = "0"  if @mail.save
        render json:result
     end


     private 
     def new_one_mail
        @mail = Vmail.new(params[:vmail])
        @mail.sent_mails = "所有人" if  @mail.sent_mails.blank?
        @mail.admin_id = session[:admin].id
     end


end
