#encoding: utf-8

module Nexus
  class PlanSeq    
    def after_save r
      r.update_attributes plan_code: gen_seq(r) if r.plan_code.blank?
    end
    
    private 
    def gen_seq r
      "#{Time.now.year}_#{PinYin.abbr r.city_name}_#{PinYin.abbr r.merchant_name}_#{PinYin.abbr r.plan_type_name}_#{PinYin.abbr r.name}_#{r.id.to_s.rjust 6,'0'}".upcase
    end
  end
end