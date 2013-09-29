#encoding : utf-8
require 'csv'
class AdminsController < ApplicationController

        before_filter :require_login , :except=>[:login,:sign_in]

  def index
        self.class.layout 'admins'
    @admins = Admin.all
    @data = session[:admin].index_top_data
    redirect_to '/admins/orders'
  end

  def logout
          session[:admin] = nil
          flash[:info] = "Thanks to use vmeal system."
      self.class.layout "admin_login"
          redirect_to login_admins_path
  end

  def login
     self.class.layout "admin_login"
         redirect_to admins_path if session[:admin]
  end

  def sign_in
          admin =  Admin.find_by_name(params[:name])
          if admin && admin.authenticate(params[:password])
                create_session admin
        self.class.layout 'admins'
                redirect_to admins_orders_path
          else
                 flash[:error] = 'Error with input username or Password'
         redirect_to login_admins_path
          end
  end

  def stores
      @stores = Store.stores_of_a_school("swpu")
      @foods = Food.hot_foods("swpu")
  end

  def users
      @users = User.order("created_at desc").paginate(:page => params[:page], :per_page => 25)
  end

  def orders
      @orders =  Order.order("created_at desc").paginate(:page => params[:page], :per_page => 25)
  end

  def finance
     @store =  Store.where("isclose < ? and name != ?",2,"微大学虚拟餐厅")
     @stores = @store.paginate(:page => params[:page], :per_page => 10)
     @sold_price = @store.map{|store| store.income_by_time(3 , Time.local(2013,03,01), Time.now)}.sum
  end

  protected
  def csv_helper(array_data)
    unless array_data.blank?
      content_type = request.user_agent =~ /windows/i ? 'application/vnd.ms-excel;':'text/csv;'
      csv_data = CSV.generate do |csv|
        csv << array_data[:header]
        array_data[:values].each do |a_line|
          row = []
          a_line.each do |a_date|
            row << a_date
          end
          csv << row
        end
      end
      csv_data = csv_data.force_encoding("GBK")
      send_data(csv_data, :type=> content_type, :filename => "#{controller_name}.csv")
    end
  end

  private
  def create_session(admin)
        session[:admin] = admin
  end

  def require_login
      unless logged_in?
         flash[:error] = "You must be logged in to access this System"
         redirect_to login_admins_path # halts request cycle
      end
  end

  def logged_in?
          session[:admin]
  end


end
