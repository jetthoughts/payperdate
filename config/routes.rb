Payperdate::Application.routes.draw do
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: {registrations: 'users/registrations',
                                                                                         sessions: 'users/sessions',
                                                                                         :omniauth_callbacks => 'users/omniauth_callbacks'}


  unauthenticated :user do
    root to: 'pages#landing', as: :guest_root
    match '*missing' => 'pages#landing', via: [:get, :post]
  end

  authenticated :user do
    root to: 'users#show'
    resources :users do
    end

    resource :me, only: :show, to: 'users#show' do
    end

    get '/profile/edit'
    match '/profile/edit', to: 'profile#update', via: [:post, :patch]
  end
  get '/about', to: 'pages#about'
end
