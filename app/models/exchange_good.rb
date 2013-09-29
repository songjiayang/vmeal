class ExchangeGood < ActiveRecord::Base
  has_attached_file :image_url,
     :styles => {
       :thumb=> "100x100#",
       :small  => "400x400>",
       :nomal  => "200x200>"}
  def get_image_url
    return image_url.url(:nomal)
  end
end
