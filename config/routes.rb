ShareCf::Application.routes.draw do
  get  'sessions', to: 'sessions#new'
  get  'users',    to: 'users#show'
  post 'users',    to: 'users#create'

  match '/auth/:provider/callback' => 'users#create'

  root to: 'sessions#new'
end
