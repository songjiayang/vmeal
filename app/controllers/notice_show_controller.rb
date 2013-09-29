class NoticeShowController < ApplicationController
  def index
    @notice = Notice.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notice }
    end
  end
end
