#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'upsmart_util'

namespace :util do
  desc "import mobile"
  task :import_mobiles => :environment do
    UpsmartUtil.new.import_mobiles
  end

  desc "import mtc and mcc"
  task :import_mtc => :environment do
    UpsmartUtil.new.import_mtc
  end
  
  desc "import city"
  task :import_city => :environment do
    UpsmartUtil.new.import_city
  end
end