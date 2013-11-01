#coding: utf-8
module Mp
  class NameMobile < ActiveRecord::Base
    belongs_to :name_list,dependent: :destroy,counter_cache: :count
    attr_accessible *column_names

    class<<self
      def list_mobiles name_list=[]
        self.where(name_list_id: name_list.collect(&:id)).collect(&:mobile).compact
      end
    end
  end
end
