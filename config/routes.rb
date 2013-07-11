Payperdate::Application.routes.draw do

  begin
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    authenticate :admin_user do
      require 'sidekiq/web'
      mount Sidekiq::Web => '/sidekiq'
    end
  rescue => ex
    p ex
  end

  devise_for :users,
             path_names:  { sign_in: 'login', sign_out: 'logout' },
             controllers: { registrations:      'users/registrations',
                            sessions:           'users/sessions',
                            omniauth_callbacks: 'users/omniauth_callbacks' }


  unauthenticated :user do
    root to: 'pages#landing', as: :guest_root
    match '*missing' => 'pages#landing', via: [:get, :post]
  end

  authenticated :user do
    resources :users do
      resource :profile

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
    end

    namespace :me, as: '' do
      resource :profile
    end

    root to: 'users#index'
  end

  get '/about', to: 'pages#about'
end
