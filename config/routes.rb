Mp::Application.routes.draw do
  namespace :plan do
    resources :personals do
      collection do
        get :options
        post :filter_user
        post :preview
      end
    end
  end

  devise_for :members, {    
    class_name: "Mp::Member",
    module: :devise
  }#:path => "mp"


  resources :marketings do
    collection do
      get :summary, :follows, :convs
    end
    member do
      get :detail, :follow, :conv
    end
  end

  resources :report do
    collection do
      get :detail,:summary
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
    post "test"
  end

  namespace :sp_result do 
    get "summary"
    get "chart"
  end

  resources :sp_reports,:only => [:index] do 
    member do 
      get :detail,:summary
    end
  end 

  root :to => 'welcome#index'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
