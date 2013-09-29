#encoding : utf-8
class Admins::PhoneListsController < AdminsController
  def index
    @short_phones = ShortPhone.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
  end
end