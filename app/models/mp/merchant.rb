#encoding: utf-8

class Mp::Merchant < ActiveRecord::Base
  self.table_name = "_mch_info"
  attr_accessible :mch_id,:mch_name,:mch_app_cate,:mch_app_label,:mch_app_logo,:mch_info,:mch_phone,:update_time

  validates :mch_name, :presence => true, :uniqueness => true
  has_many :stores,:class_name => "Mp::Store",:foreign_key => "mch_id", :dependent => :destroy
  
  #todo

  IMAGE_URL = "/system/images/merchants/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL

  before_save :preset

  def preset
    self.update_time = Time.current
  end

  def image_path
    IMAGE_PATH + self.id.to_s + "/logo.png" 
  end

  def image_url
    IMAGE_URL + self.id.to_s + "/logo.png"
  end
    
  def upload(file)
    dir = IMAGE_PATH + self.id.to_s
    unless File.exist?(dir)
      `mkdir -p #{dir}`
    end
    img = MiniMagick::Image.open(file)
    img.write(image_path)
  end

  def as_json
    ext = {
      :logo => image_url,
      :update_time => update_time.strftime("%Y-%m-%d"),
      :stores => stores.map(&:as_short_json)
    }
    super().merge!(ext)
  end

end
