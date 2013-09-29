class VmealCategoresController < ApplicationController

  before_filter :verify_not_allow_action , :only => [:new , :show ,:edit , :destroy , :index ,:update]
  # GET /vmeal_categores
  # GET /vmeal_categores.json
  def index
    @vmeal_categores = VmealCategore.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vmeal_categores }
    end
  end

  # GET /vmeal_categores/1
  # GET /vmeal_categores/1.json
  def show
    @vmeal_categore = VmealCategore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vmeal_categore }
    end
  end

  # GET /vmeal_categores/new
  # GET /vmeal_categores/new.json
  def new
    @vmeal_categore = VmealCategore.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vmeal_categore }
    end
  end

  # GET /vmeal_categores/1/edit
  def edit
    @vmeal_categore = VmealCategore.find(params[:id])
  end

  # POST /vmeal_categores
  # POST /vmeal_categores.json
  def create
    @vmeal_categore = VmealCategore.new(params[:vmeal_categore])

    respond_to do |format|
      if @vmeal_categore.save
        format.html { redirect_to @vmeal_categore, notice: 'Vmeal categore was successfully created.' }
        format.json { render json: @vmeal_categore, status: :created, location: @vmeal_categore }
      else
        format.html { render action: "new" }
        format.json { render json: @vmeal_categore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vmeal_categores/1
  # PUT /vmeal_categores/1.json
  def update
    @vmeal_categore = VmealCategore.find(params[:id])

    respond_to do |format|
      if @vmeal_categore.update_attributes(params[:vmeal_categore])
        format.html { redirect_to @vmeal_categore, notice: 'Vmeal categore was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vmeal_categore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vmeal_categores/1
  # DELETE /vmeal_categores/1.json
  def destroy
    @vmeal_categore = VmealCategore.find(params[:id])
    @vmeal_categore.destroy

    respond_to do |format|
      format.html { redirect_to vmeal_categores_url }
      format.json { head :no_content }
    end
  end
end
