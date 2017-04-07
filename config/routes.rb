Rails.application.routes.draw do
  resources :projects do
    get :chart, on: :member
    get :duration_data, on: :member
  end

  resources :builds, only: [:show]
  resources :testcases, only: [:show]
  resources :suites, only: [:show]

  resource :results do
    post :pull_results
  end

  root 'projects#index'
end
