#encoding = utf-8
class StationMailsController < ApplicationController
  # GET /station_mails
  # GET /station_mails.json
  def index
    @station_mails = StationMail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @station_mails }
    end
  end

  # GET /station_mails/1
  # GET /station_mails/1.json
  def show
    @station_mail = StationMail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @station_mail }
    end
  end

  # GET /station_mails/new
  # GET /station_mails/new.json
  def new
    @station_mail = StationMail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @station_mail }
    end
  end

  # GET /station_mails/1/edit
  def edit
    @station_mail = StationMail.find(params[:id])
  end

  # POST /station_mails
  # POST /station_mails.json
  def create
    @station_mail = StationMail.new(params[:station_mail])
    respond_to do |format|
      if @station_mail.save
        format.html { redirect_to @station_mail, notice: 'Station mail was successfully created.' }
        format.json { render json: @station_mail, status: :created, location: @station_mail }
      else
        format.html { render action: "new" }
        format.json { render json: @station_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /station_mails/1
  # PUT /station_mails/1.json
  def update
    @station_mail = StationMail.find(params[:id])

    respond_to do |format|
      if @station_mail.update_attributes(params[:station_mail])
        format.html { redirect_to @station_mail, notice: 'Station mail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @station_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /station_mails/1
  # DELETE /station_mails/1.json
  def destroy
    @station_mail = StationMail.find(params[:id])
    @station_mail.destroy

    respond_to do |format|
      format.html { redirect_to station_mails_url }
      format.json { head :no_content }
    end
  end

  def send_mail
    User.all.each do |user|
      @mail_index_user = MailIndexUser.new
      @mail_index_user.send_user_id = current_user.id
      @mail_index_user.receiver_user_id = user.id
      @mail_index_user.mail_id = params[:mail_id]
      @mail_index_user.save
    end
    render :text => "<script type='text/javascript'>alert('发送成功')</script>"
  end
end
