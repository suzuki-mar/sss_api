Rails.application.routes.draw do

  resources :problem_solvings do
    collection do
      get :recent
      get 'month/:year/:month' => 'problem_solvings#month'
    end
  end

  resources :reframings do
    collection do
      get :recent
      get 'month/:year/:month' => 'reframings#month'
    end
  end

  resources :self_cares do
    collection do
      get :recent
      get 'month/:year/:month' => 'self_cares#month'
    end
  end

  get 'api_docs/index'
  get 'api-docs', to: 'api_docs#index'
end
