class MessagesController < ApplicationController
  
  before_filter :verify_not_allow_action , :only => [:new , :show ,:edit , :destroy , :index]

  # POST /messages
  # POST /messages.json
  def create
    message={}
    message["comment"]=params[:comment]
    message["user_id"]=params[:user_id]
    message["store_id"]=params[:store_id]
    @message = Message.new(message)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end  
end
