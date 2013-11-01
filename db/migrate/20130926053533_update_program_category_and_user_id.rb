class UpdateProgramCategoryAndUserId < ActiveRecord::Migration
  def change
    Nexus::Program.all.each do |p|
      puts "\tupdate program:#{p.program_code}"
      user_id = p.plan.try(:user_id)
      category_name = p.plan.try(:creator).try(:category_name)

      p.update_attributes user_id: user_id,category_name: category_name
    end
  end
end
