#encoding : utf-8
class QingansController < AdminsController
  def index
    @qingans = Qingan.all
    render layout: "devise"
  end
end
