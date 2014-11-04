SalesForce::Application.routes.draw do

  ResqueWeb::Engine.eager_load!
  mount ResqueWeb::Engine => "/resque_web"

  resources :products, only: [:index]

  resources :credentials

  resources :mappings do

    member do
      post :dispatch_surveys
      post :clone
      post :clear_cursor
    end

    resources :salesforce_objects, only: [:create, :destroy, :update] do
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
  resources :odk_forms, only: [:index]

  get  "signup", to: "users#new",        as: :signup
  get  "login",  to: "user_sessions#new",     as: :login
  post "login",  to: "user_sessions#create",  as: :create_session
  post  "logout", to: "user_sessions#destroy", as: :logout

  get "metrics", to: "metrics#index", as: :metrics

  match "/*path" => redirect("/?goto=%{path}"), via: [:get, :post]

  root to: 'home#index'
end
