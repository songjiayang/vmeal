
class SeasonFoodsController < ApplicationController
  
  def show
    @season_food = SeasonFood.find(params[:id])
  end

end
