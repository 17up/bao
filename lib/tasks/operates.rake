# require 'thread/pool'
# require 'ruby-prof'

namespace :operates do
  desc "update operates store"
  task :store => :environment do
    # RubyProf.start

    #pool = Thread.pool(8)

    the_store_id = (_ids = ENV["store_id"]) && _ids.split(",")
    actions = OperatesService.methods(false)
    puts "#{ENV['the_month']}"
    end_date = ENV['the_month'] && (_end = Date.strptime("#{ENV['the_month']}","%Y-%m")) && _end.end_of_month.to_date || 1.months.ago.end_of_month.to_date

    # start_dates = []
    # 1.upto(3) do | per |
    #   start_dates << per.months.ago.at_beginning_of_month.to_date
    # end
    start_dates = (end_date.months_ago(3).to_date...end_date).select{|d| d.day == 1}

    (the_store_id || Mp::Store.pluck(:store_id) ).each do |store_id|
      #pool.process {
        puts "-------start pluck store #{store_id}------"
        actions.each do |action|
          start_dates.each do |start_date|
            unless OperatesStore.get(store_id, action, start_date, end_date)
              puts "-----#{store_id}:#{action}:#{start_date}:#{end_date}--add-to-redis--"
              data = OperatesService.send action, store_id, start_date, end_date
              OperatesStore.save(store_id, action, start_date, end_date, data)
            end
          end
        end
        puts "-------end pluck store #{store_id}--------"
      #}#end pool
    end
    #pool.shutdown

    # result = RubyProf.stop
    # test = caller.first =~ /in `(.*)'/ ? $1 : "test"
    # testfile_name = "/tmp/ruby_prof_#{test}.html"
    # printer = RubyProf::CallStackPrinter.new(result)
    # puts "--------testfile_name: #{testfile_name}------------------"
    # File.open(testfile_name, "w") {|f| printer.print(f, :threshold => 0, :min_percent => 0, :title => "ruby_prof #{test}")}
  end
end
