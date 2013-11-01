#!/bin/bash
export http_proxy="http://192.168.88.8:3128"
export rvm_proxy=$http_proxy

APP_DIR="/data/app/zhb/current"

if [ -d $APP_DIR ] ;then
  if [ $# -ge 1 ];then
    cd $APP_DIR
    echo "get latest sources"
    git pull
    echo "checkout special branch"
    git checkout $1
    echo "bundle install"
    bundle install
    echo "precompile assets"
    RAILS_ENV=production bundle exec rake assets:clean assets:precompile
    #tar -czf public/assets.tgz.`date +%Y%m%d%H%M%S` public/assets

    # if [ -f tmp/pids/sidekiq.pid ]
    # then 
    #     #kill -9 `cat tmp/pids/sidekiq.pid`
    #     bundle exec sidekiqctl stop tmp/pids/sidekiq.pid 10 
    # else 
    #     echo 'Sidekiq is not running'
    # fi
    # 
    # echo 'Running sidekiq'
    # nohup bundle exec sidekiq -e production -C config/sidekiq.yml -i 0 -P tmp/pids/sidekiq.pid >> log/sidekiq.log 2>&1 &
    echo "checking unicorn"
    if [ -f  tmp/pids/unicorn.pid ]
    then 
        kill -QUIT `cat tmp/pids/unicorn.pid` 
        echo "unicorn is killed"
    else
        echo 'Unicorn is not running'
    fi
    
    echo 'Running migration'
    RAILS_ENV=production bundle exec rake db:migrate

    echo 'Running unicorn'
    RAILS_ENV=production bundle exec unicorn_rails -c config/unicorn.rb -D
  else
    echo "Usage ./bin/deploy special_git_branch"
  fi
else
    echo "Invalid app path:${APP_DIR}"
fi