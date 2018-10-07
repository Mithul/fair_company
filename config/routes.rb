Rails.application.routes.draw do
  resources :rewards
  resources :companies
  namespace :admin do
      resources :companies
      resources :roles
      resources :users
      root to: "users#index"
    end
  root to: 'visitors#index'
  devise_for :users
  resources :users

  get '/apply' => 'users#apply', as: :user_apply_company
  get '/apply/:company_id' => 'users#apply_company', as: :apply_company
  get '/approvals' => 'companies#approvals', as: :applications_company
  get '/approve/:user_id' => 'companies#approve', as: :approve_user

  get '/upload_receipt/:company_id' => 'users#upload_receipt', as: :upload_receipt
  get '/rate/:company_id' => 'companies#rate', as: :rate_company

  post '/ratings' => 'companies#save_rating' , as: :ratings

  get '/redeem/:reward_id' => 'rewards#redeem', as: :redeem_reward

end
