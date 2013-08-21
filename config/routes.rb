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


  unauthenticated :user do
    root to: 'pages#landing', as: :guest_root
    match '*missing' => 'pages#landing', via: [:get, :post]
  end

  get :unsubscribe, to: "users#unsubscribe"

  authenticated :user do
    resources :users do
      resource :profile

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
      resources :avatars do
        member do
          post :use
        end
      end
      resources :albums do
        resources :photos
      end
      resources :winks, only: [:create, :index]
      resources :invitations do
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
      resource :favorites, to: 'me/favorites#index'
    end

    namespace :me, as: '' do
      resource :profile
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
    end

    root to: 'users#index'

    get '/search', to: 'users#search'
  end
  get '/about', to: 'pages#about'
end
