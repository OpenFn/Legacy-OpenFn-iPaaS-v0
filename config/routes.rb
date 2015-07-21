require 'sidekiq/web'
require 'admin_constraint'

OpenFn::Application.routes.draw do

  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'

  resources :password_resets

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  get "submissions_controller/index"

  resource :payment_notification, only: [] do
    post :completed
    get :success
    get :failure
  end

  # slightly weird, but we're getting this from Salesforce in xml, and they always post.
  post "/api/v1/:token/update_products", to: "products#update", defaults: { format: 'xml' }
  post "/api/v1/:token/update_users", to: "users#sync", defaults: { format: 'xml' }

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

  namespace :api do
    namespace :v1 do
      # We don't need to list of describe the new mappings yet.
      resources :mappings, only: [:show, :create, :update]

      resources :connection_profiles, only: [:index, :edit, :create]

      resources :credentials, only: [:index, :create, :edit]

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

  resources :charges

  resources :reviews, only: [:create, :index, :show]

  resources :products, only: [:index, :show]

  resources :review_votes, only: [:create, :show, :index]

  resources :tags, only: []

  resources :tag_categories, only: [:show, :index]

  resources :odk_forms, only: [:index]

  resource :welcome_stats, only: :show

  resources :organizations

  resources :projects do
    resources :collaborations, only: [:new, :create, :update, :destroy]
  end

  get  "signup", to: "users#new",        as: :signup
  get  "login",  to: "user_sessions#new",     as: :login
  post "signup", to: "users#create"
  post "login",  to: "user_sessions#create",  as: :create_session
  post  "logout", to: "user_sessions#destroy", as: :logout
  post :send_invite, to: 'users#send_invite'
  match :set_password, to: 'users#set_password', via: [:get, :post]
  post :receive_stripe_events, to: 'webhooks#receive_stripe_events'
  get "check_plan", to: "users#check_plan"



  get '/products/:product_id/vote', to: "products#vote"
  get '/products/:product_id/review/show', to: "reviews#index"
  post '/products/:product_id/review/new', to: "reviews#create"
  get '/product/:product_id/rating', to: "reviews#product_rating"
  post '/products/:product_id/admin_edit', to: "products#admin_edit"

  get '/review/:review_id/up_vote', to: "review_votes#upvote"
  get '/review/:review_id/down_vote', to: "review_votes#downvote"
  get '/review/:review_id/score', to: "review_votes#count_rating"
  get '/products/:product_id/tags', to: "tags#product_tags"
  post '/products/:product_id/tags/add', to: "tags#product_tags_add"
  get '/tag/tagging_count/:tag_id', to: "tags#tagging_count"
  get '/tags/get_all_json', to: "tags#get_all_json"

  get "metrics", to: "metrics#index", as: :metrics
  get '/user/check_login', to: "users#check_login"

  post '/admin/products/:product_id/tags/add', to: "tags#tags_add"
  post '/admin/products/:product_id/tags/delete', to: "tags#tags_delete"

  # to solve issue rendering json on /tags, redirecting to /tag
  #match "/tags" => redirect("/tag"), via: [:get]
  #match "/tags/index" => redirect("/tag"), via: [:get]

  # changes tags/index to tags/get_all
  get '/tags/get_all', to: "tags#get_all"

  namespace :admin do
    resources :drafts, only: [:index, :show, :update, :destroy]
  end

  match "/*path" => redirect("#/%{path}"), via: [:get, :post]

  root to: 'home#index'
  # root to: 'mappings#index'
end
