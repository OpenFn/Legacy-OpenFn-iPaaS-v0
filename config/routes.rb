SalesForce::Application.routes.draw do

  root to: 'mappings#index'
  resources :mappings do
    collection do
      get :get_salesforce_fields
    end
  end
end