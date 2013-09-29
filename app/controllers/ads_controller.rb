
class AdsController < ApplicationController
  
  before_filter :authenticate_with_admin, :set_layout

  def index
  	@ads = Ads.all
  end

  def edit
  	@ad = Ads.find(params[:id].to_i)
  end

  def destroy
  end

  def create
  end

  def show
     render json: Ads.find(params[:id].to_i)  
  end

  private 
  def set_layout
  	 self.class.layout  "admins"
  end


end
