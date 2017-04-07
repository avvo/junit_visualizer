Rails.application.routes.draw do
  resources :projects

  resources :builds, only: [:show]
  resources :testcases, only: [:show]
  resources :suites, only: [:show]

  resource :results do
    post :pull_results
  end

  root 'projects#index'
end
