Payperdate::Application.routes.draw do

  begin
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    authenticate :admin_user do
      match '/delayed_job' => DelayedJobWeb, anchor: false, via: [:get, :post, :delete, :patch]
    end
  rescue => ex
    p ex
  end

  devise_for :users,
             path_names:  { sign_in: 'login', sign_out: 'logout' },
             controllers: { registrations:      'users/registrations',
                            sessions:           'users/sessions',
                            omniauth_callbacks: 'users/omniauth_callbacks',
                            passwords:          'users/passwords' }


  resources :venues do
    collection do
      get :search
      get :yelp
      get :list
      get :google_list
      get :foursquare_list
    end
  end
  namespace :eventful do
    resources :venues
    resources :events
  end
  get '/about', to: 'pages#about'
  get :unsubscribe, to: "users#unsubscribe"

  unauthenticated :user do
    root to: 'pages#landing', as: :guest_root
    match '*missing' => 'pages#landing', via: [:get, :post]
  end

  authenticated :user do
    resources :users do
      resource :profile
      resource :invitations, only: :create
      resource :winks, only: :create
      resource :gifts, only: [:new, :create]
      resource :member_reports, only: [:new, :create]
      resource :message, only: [:new, :create]
      resources :albums, only: :index do
        resources :photos, only: :index
      end

      member do
        post :block
        post :unblock
        post :favorite
        post :remove_favorite
      end
    end

    get '/me', to: 'me/profiles#show'

    scope :me do
      resources :avatars, controller: 'me/avatars' do
        member do
        end
      end
      resources :albums do
        resources :photos do
          post :use_as_avatar
        end
      end
      resources :winks, only: :index
      resources :invitations, only: [:index, :destroy] do
        collection do
          get :accepted
          get :rejected
          get :sent
        end
        member do
          post :accept
          post :reject
          patch :counter
        end
      end
      resources :credits do
        member do
          get :complete_purchase
        end
      end

      resource :blocks, to: 'me/blocks#index'
      get :favorites, to: 'me/favorites#index'
      get :viewers, to: 'me/viewers#index'
      get :back_favorites, to: "me/favorites#back"
    end

    scope :me, module: 'me' do
      resource :profile
      resource :settings, only: [:edit, :update]
      resource :email_invitation, only: [:new, :create]
      resources :users_dates, only: [:index] do
        resources :date_ranks, only: [:new, :create]
        collection do
          get :unlocked
          get :locked
        end
        member do
          post :unlock
        end
      end
      resources :messages, only: [:index, :show, :destroy] do
        collection do
          get :unread
          get :sent
          get :received
        end
      end
      resources :conversations, only: [:index, :show]
    end

    root to: 'users#index'

    get '/search', to: 'users#search'
  end
end
