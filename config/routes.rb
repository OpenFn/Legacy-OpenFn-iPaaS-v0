SalesForce::Application.routes.draw do

  ResqueWeb::Engine.eager_load!
  mount ResqueWeb::Engine => "/resque_web"

  root to: 'mappings#index'

  resources :mappings do

    member do
      post :dispatch_surveys
      post :clone
    end

    resources :salesforce_objects
    resource :odk_form
    resources :odk_fields do
      resources :odk_field_salesforce_fields
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
  get  "login",  to: "user_sessions#new",     as: :login
  post "login",  to: "user_sessions#create",  as: :create_session
  post  "logout", to: "user_sessions#destroy", as: :logout
end
