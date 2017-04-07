Rails.application.routes.draw do
  resources :projects

  resources :builds

  resource :results do
    post :pull_results
  end

  root 'projects#index'
end
