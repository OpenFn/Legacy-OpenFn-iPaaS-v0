SalesForce::Application.routes.draw do

  ResqueWeb::Engine.eager_load!
  mount ResqueWeb::Engine => "/resque_web"

  root to: 'home#index'
  resources :mappings do

    member do
      post :dispatch_surveys
      post :clone
    end

    collection do
      get :get_odk_forms
      get :get_salesforce_fields
    end
  end

  resources :users

  resources :odk_forms, only: [:index] do
    resources :odk_form_fields, only: [:index]
  end

  resources :salesforce_objects, only: [:index] do
    resources :salesforce_object_fields, only: [:index]
  end

  get  "signup", to: "users#new",        as: :signup
  post "login",  to: "user_sessions#create",  as: :create_session
  get  "login",  to: "user_sessions#new",     as: :login
  post  "logout", to: "user_sessions#destroy", as: :logout
end
