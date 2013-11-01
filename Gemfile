# coding: utf-8

if File.exists?('Gemfile.local') then
  eval File.read('Gemfile.local'), nil, 'Gemfile.local'
end

source 'http://ruby.taobao.org/'

gem 'rails', '4.0.0'
gem 'mysql2'

#i18n
gem 'rails-i18n'

#paginate
gem 'kaminari'

#AR
# gem 'squeel'
gem 'protected_attributes'

#文件上传组件
gem 'carrierwave'
gem "mini_magick"

#中文转拼音
gem 'ruby-pinyin'

#Auth
gem "devise"
gem 'cancan'

#批量操作数据
gem 'activerecord-import'
# gem 'squeel'

# Cron jobs
gem 'whenever', :require => false

gem 'redis'


gem 'therubyracer'
gem 'uglifier'
gem 'haml_coffee_assets'
gem 'turbolinks'
gem "less-rails"
gem 'coffee-rails'
gem 'sass-rails'
gem "twitter-bootstrap-rails"
gem 'bourbon'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails', '~> 2.1.4'

gem 'jbuilder'

gem "remotipart", '~> 1.0'
gem "httparty"

# YAML settings
gem "settingslogic", "~> 2.0.9"

gem 'mongoid', github: "mongoid/mongoid"
gem 'bson_ext'

group :development do
  # gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'quiet_assets'
  gem 'capistrano'
  gem "rvm-capistrano"
  gem 'thin'
  #profile
  #gem 'rack-mini-profiler'
end

group :test do
  gem 'factory_girl_rails'
end

group :production do
  gem "unicorn"
end

gem 'exception_logger', github: 'martinx/exception_logger'