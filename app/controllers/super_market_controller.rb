#encoding:utf-8
class SuperMarketController < ApplicationController
  def show
    @super_market = Store.find_market
    if params[:id]=='show'
      @foods = Food.find_super_market_food(@super_market.categories[0].id)
      @flag=@super_market.categories[0].id
    else
      @foods = Food.find_super_market_food(params[:id])
      @flag=params[:id]
    end
  end
end