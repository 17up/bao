module PlanOps
  module Member
    def update_custom_plan plan, config={}
      push_time = config[:push_time]
      begin_hour, end_hour =(push_time.is_a?(Array) ? push_time.first : (push_time||'')).split('-')

      target = plan.target
      target.update_attributes sms_content: config[:push_content]
      plan.update_attributes name: config[:name]||config[:program_name]
      program = plan.programs.first

      program.update_attributes program_name: plan.name, program_code: plan.plan_code, begin_at: config[:begin_date], end_at: config[:end_date]
      mobiles = (config[:mobiles]||'').split(',')

      program.tasks.delete_all

      task = program.tasks.create begin_date: config[:begin_date], end_date: config[:begin_date], begin_hour: begin_hour,
                                  end_hour: end_hour, task_type: 1, task_status: 0, plan_count: mobiles.length

      Nexus::TaskUser.where(program_id: program.id).delete_all
      users = []
      mobiles.each do |mobile|
        mobile = (mobile||'').gsub ' ', ''
        users << Nexus::TaskUser.new(target_id: target.id, program_id: program.id, mobile: mobile, channel: 1000, task_id: task.id,
                                     service_id: '005', push_status: 0, push_type: 1, user_id: 0) if mobile=~ /\d{11}/
      end

      Nexus::TaskUser.import users, :validate => false

      plan.update_attributes push_number: users.length
      program.update_attributes plan_count: users.length
      
      plan
    end


    def create_custom_plan config={}
      target = create_target config
      plan = create_plan target, config
      program =create_program plan, config
      begin_hour, end_hour = (config[:push_time]||'').split('-')

      mobiles = (config[:mobiles]||'').split(',')

      task = program.tasks.create begin_date: config[:begin_date], end_date: config[:begin_date], begin_hour: begin_hour,
                                  end_hour: end_hour, task_type: 1, task_status: 0, plan_count: mobiles.length

      users = []
      mobiles.each do |mobile|
        mobile = (mobile||'').gsub ' ', ''
        users << Nexus::TaskUser.new(target_id: target.id, program_id: program.id, mobile: mobile, channel: 1000, task_id: task.id,
                                     service_id: '005', push_status: 0, push_type: 1, user_id: 0) if mobile=~ /\d{11}/
      end

      target.update_attributes task_id: task.id, program_id: program.id, plan_count: users.length

      Nexus::TaskUser.import users, :validate => false
      plan.update_attributes push_number: users.length
      program.update_attributes plan_count: users.length
      plan
    end

    def create_personal_plan config = {}
      push_time = (config[:push_time].first ||'').split(',')
      push_date = (config[:push_date].first||'').split(',')
      push_number = (config[:push_number_perday].first||'').split(',')

      target = create_target config
      plan = create_plan target, config
      program =create_program plan, config

      push_date.each_with_index do |date, index|
        begin_hour, end_hour = (push_time[index]||'').split('-')
        #todo:add target
        task = program.tasks.create begin_date: date, end_date: date, begin_hour: begin_hour,
                                    end_hour: end_hour, task_type: 1, task_status: 0, plan_count: push_number[index]
        _target = Nexus::Target.create sms_content: config[:push_content], task_id: task.id, program_id: program.id, plan_count: push_number[index]

      end

      total_push_number = push_number.inject(0) { |sum, i| sum + i.to_i }
      plan.update_attributes push_number: total_push_number
      program.update_attributes plan_count: total_push_number
      plan
    end

    def update_personal_plan plan, config={}
      push_time = (config[:push_time].first ||'').split(',')
      push_date = (config[:push_date].first||'').split(',')
      push_number = (config[:push_number_perday].first||'').split(',')

      target = plan.target
      target.update_attributes sms_content: config[:push_content]
      plan.update_attributes name: config[:name]||config[:program_name]

      program = plan.programs.first
      program.update_attributes program_name: plan.name, program_code: plan.plan_code, begin_at: config[:begin_date], end_at: config[:end_date]

      program.tasks.delete_all

      push_date.each_with_index do |date, index|
        begin_hour, end_hour = (push_time[index]||'').split('-')
        program.tasks.create begin_date: date, end_date: date, begin_hour: begin_hour,
                             end_hour: end_hour, task_type: 1, task_status: 0, plan_count: push_number[index]
      end

      # PlanWorker.perform_async(plan.id)
      p push_number.inject(0) { |sum, i| sum + i.to_i }
      p (target.sms_content.to_f/64.to_f).ceil
      p push_number.inject(0) { |sum, i| sum + i.to_i } * (target.sms_content.to_f/64.to_f).ceil
      total_push_number = push_number.inject(0) { |sum, i| sum + i.to_i }

      plan.update_attributes push_number: total_push_number
      program.update_attributes plan_count: total_push_number
      plan
    end

    def create_target config={}
      Nexus::Target.create sms_content: config[:push_content]
    end

    def create_plan target, config={}
      unless store_id.blank?
        store = Mp::Store.find store_id
        config[:search_id] = store.search_id
      end

      target.plans.create store_id: store_id, merchant_id: merchant_id, search_id: config[:search_id], name: config[:name]||config[:program_name], status: 0, city: city,
                          plan_type: config[:plan_type], user_id: self.id,plan_category: plan_category(config)
    end

    def plan_category config
      current_controller_name config
    end

    def create_program plan, config
      plan.programs.create program_name: plan.name, program_code: plan.plan_code, program_status: 0, model_type: config[:model_type],
                           program_type: plan.plan_type, begin_at: config[:begin_date], end_at: config[:end_date], model_type: config[:model_type]||'target'
    end

    def create_name_list config={}
      name_list = Mp::NameList.create name: config[:name], user_id: self.id, merchant_id: self.merchant_id, store_id: self.store_id

      (config[:mobiles]||'').split(',').each do |mobile|
        name_list.name_mobiles.create mobile: mobile if mobile=~ /\d{11}/
      end

      name_list
    end
    
  end
end