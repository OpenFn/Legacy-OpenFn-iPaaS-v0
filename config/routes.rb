SalesForce::Application.routes.draw do

  root to: 'mappings#index'
  resources :mappings
end