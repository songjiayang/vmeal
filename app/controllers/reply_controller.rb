class ReplyController < ApplicationController

	def create
		 Reply.create(params[:reply]) if Store.find(session[:store_id]).messages.map { |e| e.id.to_s }.include?(params[:reply][:message_id])
     redirect_to "/stores/edit/messages"
	end

	def show
     reply = Reply.find(params[:id]) if Store.find(session[:store_id]).messages.map { |e| e.reply.id.to_s  if e.reply}.include?(params[:id])
		 render json: reply.comment
	end
end
