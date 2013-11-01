#encoding: utf-8

module Nexus
  class SmsCount    
    def after_save r
      if r.plan_count.blank?
        puts "count is null,return"
        return 
      end
      
      history = PackageOrderHistory.history(r.id).first
      
      plan = r.plan
      target = plan.target
      
      history_config = {status: 'pending',count: r.plan_count,plan_id: plan.id,program_id: r.id,program_code: r.program_code,merchant_id: plan.merchant_id,name: plan.plan_category}
      
      current_count = r.plan_count * (target.sms_content.length.to_f/64.to_f).ceil
      
      PackageOrderHistory.with_draw(r.id,r.merchant?) if !history.nil? && history.pending?
      
      if history.nil?
        p = PackageOrderHistory.create history_config
        PackageOrder.where(name: plan.plan_category,merchant_id: plan.merchant_id).order(created_at: :asc).each do |o|
          next if o.remain <= 0
          
          history_config = history_config.merge(package_order_id: o.id,order_id: o.order_id,order_item_id: o.order_item_id,package_id: o.package_id,
                                count: o.remain,last_count: o.remain,package_category: o.package_category,parent_id: p.id)
                                
          if o.remain > current_count
            history_config[:count] = current_count
            PackageOrderHistory.create history_config
            o.update_attributes used: o.used+current_count if r.merchant?
            break
          else
            PackageOrderHistory.create history_config
            o.update_attributes used: o.used+o.remain if r.merchant?
            current_count -= o.remain
          end
        end
      end
    end
  end
end