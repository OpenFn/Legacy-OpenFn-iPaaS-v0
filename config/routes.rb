SalesForce::Application.routes.draw do

  root to: 'mappings#index'
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

  resources :odk_forms, only: [:index] do
    resources :odk_form_fields, only: [:index]
  end

  resources :salesforce_objects, only: [:index] do
    resources :salesforce_object_fields, only: [:index]
  end

end
