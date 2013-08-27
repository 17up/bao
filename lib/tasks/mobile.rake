#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'util/mobiles'

namespace :util do
  namespace :mobile do

    desc "import mobile"
    task :import => :environment do
      Util::Mobiles.new.execute
    end

  end
end