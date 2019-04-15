Rails.application.routes.draw do

  namespace :actions do
    get :doing
    get :done
    get :search
  end

  get 'documents/tags'

  get 'tags' => 'tags#index'

  resources :problem_solvings do
    collection do
      get :recent
      get 'month/:year/:month' => 'problem_solvings#month'
      post :init
      put 'auto_save/:id' => 'problem_solvings#auto_save'
      put 'done/:id' => 'problem_solvings#done'
      put 'doing/:id' => 'problem_solvings#doing'
      get 'doings/:year/:month' => 'problem_solvings#doings'
      get 'dones/:year/:month' => 'problem_solvings#dones'
    end
  end

  resources :reframings do
    collection do
      get :recent
      get 'month/:year/:month' => 'reframings#month'
      post :init
      put 'auto_save/:id' => 'reframings#auto_save'
    end
  end

  resources :self_cares do
    collection do
      get :recent
      get 'month/:year/:month' => 'self_cares#month'
      post 'current' => 'self_cares#current_create'
      get 'log_date_line_graph/:year/:month' => 'self_care_charts#log_date_line_graph'
      get 'point_pie_chart/:year/:month' => 'self_care_charts#point_pie_chart'
      get :recored_now
    end
  end

  resources :self_care_classifications, :only => [:update, :create, :index]

  get 'documents/search'

  get 'api_docs/index'
  get 'api-docs', to: 'api_docs#index'
end
