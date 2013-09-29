#encoding = utf-8
class Admins::StationMailsController < AdminsController
  # GET /station_mails
  # GET /station_mails.json
  def index
    @station_mails = StationMail.all
  end

  # GET /station_mails/1
  # GET /station_mails/1.json
  def show
    @station_mail = StationMail.find(params[:id])
  end

  # GET /station_mails/new
  # GET /station_mails/new.json
  def new
    @station_mail = StationMail.new
  end

  # GET /station_mails/1/edit
  def edit
    @station_mail = StationMail.find(params[:id])
  end

  # POST /station_mails
  # POST /station_mails.json
  def create
    @station_mail = StationMail.new(params[:station_mail])
    if @station_mail.save
      flash[:success] = "编号为#{@station_mail.id}站内信创建成功"
      redirect_to "/admins/station_mails/"
    else
      flash[:error] = "编号为#{@station_mail.id}站内信创建失败"
      redirect_to "/admins/station_mails/new"
    end
  end

  # PUT /station_mails/1
  # PUT /station_mails/1.json
  def update
    @station_mail = StationMail.find(params[:id])

    if @station_mail.update_attributes(params[:station_mail])
      flash[:success] = "编号为#{@station_mail.id}站内信更新成功"
      redirect_to "/admins/station_mails/"
    else
      flash[:error] = "编号为#{@station_mail.id}站内信更新失败"
      redirect_to "/admins/station_mails/"+params[:id].to_s+"/edit"
    end
  end

  # DELETE /station_mails/1
  # DELETE /station_mails/1.json
  def destroy
    @station_mail = StationMail.find(params[:id])
    begin
      @station_mail.destroy
      MailIndexUser.where(:mail_id =>params[:id]).destroy_all
      flash[:success] = "编号为#{@station_mail.id}站内信删除成功"
      redirect_to "/admins/station_mails/"
    rescue
      flash[:success] = "编号为#{@station_mail.id}站内信删除失败"
      redirect_to "/admins/station_mails/"
    end
  end

  def send_mail
    mail = StationMail.find(params[:mail_id])
    @users = params[:send_to_user].nil?? User.all : User.convert_email_to_users(params[:emails])
    begin
      send_email_to_user(@users,mail)
    rescue
    end
    redirect_to "/admins/station_mails/"
  end

  def new_user
    @station_mails = StationMail.all
  end

  private

  def send_email_to_user users,station_mail
    users.each do |user|
      @mail_index_user = MailIndexUser.new
      @mail_index_user.send_user_id = session[:admin].id
      @mail_index_user.receiver_user_id = user.id
      @mail_index_user.mail_id = station_mail.id
      @mail_index_user.save
    end
  end

end
