Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  devise_for :users,path: '',path_names:{
    sign_in: 'login',
    sign_out: 'logout',
    registrations: 'signup',
    password: 'password/reset'
  },
  controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'

  }
  devise_scope :user do
    post '/signup', to: 'users/registrations#create'
    patch '/update', to: 'users/registrations#update'
    delete '/logout', to: 'users/sessions#destroy'
    post '/login', to: 'users/sessions#create'
    post 'users/forgot-password', to: 'users/passwords#forgot', as: 'users_password_forgot'
    post 'users/reset-password', to: 'users/passwords#reset', as: 'users_password_reset'

    # New route to show user details
    get '/users/:id', to: 'users#show', as: 'user'

  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/total_amount', to: 'incomes#total_amount'

  resources :incomes do
    collection do
      put :update_projected_income
    end
  end
end
