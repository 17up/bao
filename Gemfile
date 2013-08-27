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

gem "unicorn"

#中文转拼音
gem 'ruby-pinyin'

#Auth
gem "devise"
gem 'cancan'

#记录异常信息
gem 'exception_logger', :git => 'git://github.com/martinx/exception_logger.git'

#redis相关操作
gem 'redis'
gem 'sidekiq'

#批量操作数据
gem 'activerecord-import'

gem 'therubyracer'
gem 'uglifier'
gem 'haml_coffee_assets'
gem 'turbolinks'
gem "less-rails"
gem 'coffee-rails'
gem 'sass-rails'
gem "twitter-bootstrap-rails"
gem "rails-backbone"
gem 'bourbon'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'

gem 'jbuilder'

gem "remotipart", '~> 1.0'
gem "httparty"

group :development, :test do
  #gem 'rspec-rails', '~> 2.10.0'
  gem 'factory_girl_rails'
  gem 'quiet_assets'
  gem 'database_cleaner'
  gem 'capistrano'
  gem "rvm-capistrano"
  gem 'thin'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end