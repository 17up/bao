#encoding: utf-8

class Mp::Mlog < ActiveRecord::Base
  self.table_name = "_log_info"
  attr_accessible *column_names
  
  belongs_to :store, :class_name => "Mp::Store",:foreign_key => "store_id"

  before_save :preset
  
  class << self
    def page_info(page)
      pages = self.count%PER_PAGE == 0 ? self.count/PER_PAGE : (self.count/PER_PAGE + 1)
      {
        pages: pages,
        page: page,
        next: page.to_i < pages,
        prev: page.to_i > 1
      }
    end

    def join_mid_tid(mid,tid)
      name = ""
      if mid.present?			
        name += ("mid_" + mid.split(",").sort.join("_"))
      end
      if tid.present?
        name += ("_tid_" + tid.split(",").sort.join("_"))
      end	
      name	
    end
  end

  def h_mid
    a = name.split("tid")
    mid = a[0].split("_")
    mid.shift
    mid = mid.join(",")
  end

  def h_tid
    a = name.split("tid")
    if a[1]
      tid = a[1].split("_") 
      tid.shift
      tid = tid.join(",")
    end
  end

  def search_name
    city + "_" + id.to_s
  end

  def preset
    self.time = Time.current
    self.status = 0
  end

  def as_json
    ext = {
      :name => name.split("_")[0..1],
      :search_name => search_name
    }
    super().merge(ext)
  end
end
