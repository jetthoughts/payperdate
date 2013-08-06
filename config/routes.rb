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
                            omniauth_callbacks: 'users/omniauth_callbacks' }


  resources :users do
    resource :profile

    resources :albums, only: :index do
      resources :photos, only: :index
    end
  end

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

      resources :albums, only: :index do
        resources :photos, only: :index
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
    end

    namespace :me, as: '' do
      resource :profile
    end

    root to: 'users#index'

    get '/search', to: 'users#search'
  end
  get '/about', to: 'pages#about'
end
