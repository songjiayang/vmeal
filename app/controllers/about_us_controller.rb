#encoding : utf-8
class AboutUsController < ActionController::Base
  layout 'application'
  def about_link
    @type = params[:type].to_s
    case @type
    when "aboutus"
      render "/about_us/aboutus"
    when "contactus"
      render "/about_us/contactus"
    when "dianrui"
      render "/about_us/dianrui"
    when "joinus"
      render "/about_us/joinus"
    when "legal"
      render "/about_us/legal"
    when "protocol"
      render "about_us/protocol"
    else
      render "/about_us/aboutus"
    end
  end
end
