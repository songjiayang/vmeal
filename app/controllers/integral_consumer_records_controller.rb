#encoding = utf-8
class IntegralConsumerRecordsController < ApplicationController
  before_filter :is_super_men?
  # GET /integral_consumer_records
  # GET /integral_consumer_records.json
  def index
    @integral_consumer_records = IntegralConsumerRecord.all
    render :layout => "store_center"
  end

  # GET /integral_consumer_records/1
  # GET /integral_consumer_records/1.json
  def show
    @integral_consumer_record = IntegralConsumerRecord.find(params[:id])
    render json:@integral_consumer_record
    # respond_to do |format|
      # format.html # show.html.erb
      # format.json { render json: @integral_consumer_record }
    # end
  end

  # GET /integral_consumer_records/new
  # GET /integral_consumer_records/new.json
  def new
    @integral_consumer_record = IntegralConsumerRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @integral_consumer_record }
    end
  end

  # GET /integral_consumer_records/1/edit
  def edit
    @integral_consumer_record = IntegralConsumerRecord.find(params[:id])
  end

  # POST /integral_consumer_records
  # POST /integral_consumer_records.json
  def create
    @integral_consumer_record = IntegralConsumerRecord.new(params[:integral_consumer_record])

    respond_to do |format|
      if @integral_consumer_record.save
        format.html { redirect_to @integral_consumer_record, notice: 'Integral consumer record was successfully created.' }
        format.json { render json: @integral_consumer_record, status: :created, location: @integral_consumer_record }
      else
        format.html { render action: "new" }
        format.json { render json: @integral_consumer_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /integral_consumer_records/1
  # PUT /integral_consumer_records/1.json
  def update
    @integral_consumer_record = IntegralConsumerRecord.find(params[:id])

    respond_to do |format|
      if @integral_consumer_record.update_attributes(params[:integral_consumer_record])
        format.html { redirect_to @integral_consumer_record, notice: 'Integral consumer record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @integral_consumer_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /integral_consumer_records/1
  # DELETE /integral_consumer_records/1.json
  def destroy
    @integral_consumer_record = IntegralConsumerRecord.find(params[:id])
    @integral_consumer_record.destroy

    respond_to do |format|
      format.html { redirect_to integral_consumer_records_url }
      format.json { head :no_content }
    end
  end
  
  def change_status
    @integral_consumer_record = IntegralConsumerRecord.find(params[:id])
    if @integral_consumer_record.update_attribute(:status , 1)
      redirect_to  integral_consumer_records_path 
    end
  end
  
  private

  def is_super_men?
    if session[:super_men].nil?
      redirect_to login_super_men_path  ,notice:"小贼，休想逃过我的检查"
    end
  end
end
