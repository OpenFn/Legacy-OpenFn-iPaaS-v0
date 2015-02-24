require 'sidekiq/web'
require 'admin_constraint'

SalesForce::Application.routes.draw do

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  get "submissions_controller/index"

  resources :blog_posts, only: [:index]

  resource :payment_notification, only: [] do
    post :completed
    get :success
    get :failure
  end

  # slightly weird, but we're getting this from Salesforce in xml, and they always post.
  post "/api/v1/:token/update_products", to: "products#update", defaults: { format: 'xml' }
  post "/api/v1/:token/update_blog_posts", to: "blog_posts#update", defaults: { format: 'xml' }
  post "/api/v1/:token/update_users", to: "users#sync", defaults: { format: 'xml' }

  resources :credentials

  namespace :odk_sf_legacy, shallow_path: nil, path: nil do
    resources :mappings do

      member do
        post :dispatch_surveys
        post :clone
        post :clear_cursor
      end

      resources :salesforce_objects, only: [:create, :destroy, :update] do

        member do
          get :refresh_fields
        end

        resources :salesforce_object_fields, only: [:index]
        resources :salesforce_relationships, only: [:create, :destroy]
      end
      resource :odk_form
      resources :odk_fields do
        resources :odk_field_salesforce_fields
      end

      collection do
        get :get_odk_forms
        get :get_salesforce_fields
      end

      resources :submissions do
        member do
          post :reprocess
        end
      end
    end
  end

  namespace :metrics do
    get "organisation_integration_mappings", to: "organisation_integration_mappings#index", as: :organisation_integration_mappings
  end

  namespace :api do
    resources :integration, param: :api_key do
      resource :message, only: [:create]
    end
  end

  resources :users

  resources :products, only: [:index, :show]

  resources :odk_forms, only: [:index]

  resource :welcome_stats, only: :show

  resources :organizations

  resources :projects do
    resources :collaborations, only: [:new, :create, :update, :destroy]
  end

  resources :connected_apps do
    member do
      get 'object_description/:identifier', to: 'object_descriptions#show'
      get 'object_descriptions/new', to: 'object_descriptions#new'
      post 'object_descriptions', to: 'object_descriptions#create'
      get 'object_descriptions/:identifier/edit', to: 'object_descriptions#edit'
      patch 'object_description/:identifier', to: 'object_descriptions#update'
      delete 'object_description/:identifier', to: 'object_descriptions#destroy'
    end
  end

  get  "signup", to: "users#new",        as: :signup
  get  "login",  to: "user_sessions#new",     as: :login
  post "login",  to: "user_sessions#create",  as: :create_session
  post  "logout", to: "user_sessions#destroy", as: :logout
  post :send_invite, to: 'users#send_invite'

  get "metrics", to: "metrics#index", as: :metrics

  match "/*path" => redirect("/?goto=%{path}"), via: [:get, :post]

  root to: 'home#index'
  # root to: 'mappings#index'
end
