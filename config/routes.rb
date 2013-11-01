Mp::Application.routes.draw do
  resources :agents do
    member do
      post :bind_account,:freeze_agent,:restore_agent
    end
    
    collection do
      get :list
    end
  end

  resources :merchant_categories do
    collection do
      get :select
    end
  end

  resources :orders

  resources :accounts do 
    collection do
      get :available_sms_count
    end
    
    member do
      post :change_password
    end
  end
  
  resources :cities
  resources :packages do
    member do 
      get :cal_total_price,:promo_price
    end
    collection do
      get :basic_for_select,:basic,:added,:promos
    end
  end
  
  namespace :plan do
    concern :plan_manage do
      collection do
        get   :options
        post  :filter_user
        get   :filter_user
        post  :preview
      end
      
      member do
        get   :mobiles
      end
    end

    resources :personals,concerns: :plan_manage
    resources :customs  ,concerns: :plan_manage
    resources :unions   ,concerns: :plan_manage
    resources :plans    ,concerns: :plan_manage
    resources :returns  ,concerns: :plan_manage
    resources :news     ,concerns: :plan_manage
    resources :merchants,concerns: :plan_manage
    resources :models   ,concerns: :plan_manage
  end

  resources :name_lists do
    collection do
      get :mobiles
    end
  end
  post '/merchants/:id/update',to: 'merchants#update'
  resources :merchants do
    member do
      post :bind_account,:bind_package,:freeze_merchant,:restore_merchant,:update
      get  :detail,:download_mid_file
    end
    collection do
      get :list,:info_for_buy,:info_for_usage,:info_for_package,:info,:available_sms_count
    end 
  end
  devise_for :members, class_name: "Mp::Member"#,:controllers => {:sessions => "sessions"}
  
  resources :marketings do
    collection do
      get :summary, :follows, :convs, :weidian_detail, :weidian_follow, :weidian_conv
    end
    member do
      get :detail, :follow, :conv
    end
  end

  resources :operates do
    collection do
      get :overview, :dealrecord, :feature, :dealflow, :check, :latestoverview
    end
  end

  resources :report do
    collection do
      get :detail, :summary
    end
  end

  namespace :mp do
    get "consume"
    get "app_visit"
    get "plan_list"
    get "report_list"
    get "report"
    post "save_plan"
    post "preview_plan"
  end

  namespace :sp_result do
    get "summary"
    get "chart"
  end

  resources :sp_reports, :only => [:index] do
    member do
      get :detail, :summary, :program
    end
  end

  root :to => 'welcome#index'

  namespace :api do
    post "store2merchant/notify"
    get "store2merchant/weidian"
  end
end
