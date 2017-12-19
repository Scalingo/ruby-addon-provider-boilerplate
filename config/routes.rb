Rails.application.routes.draw do
  namespace :scalingo do
    get '/sso', to: 'sso#sso'
    resources :resources, only: [:create, :destroy, :update] do
      post :suspend
      post :resume
    end
  end
end
