Rails.application.routes.draw do
  resources :projects do
    member do
      get :slowest_tests
      get :unstable_tests
    end
  end

  resources :builds, only: [:show]
  resources :testcases, only: [:show]
  resources :suites, only: [:show]

  resource :results do
    post :pull_results
  end

  root 'projects#index'
end
