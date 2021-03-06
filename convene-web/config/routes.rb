Rails.application.routes.draw do
  passwordless_for :people

  namespace :admin do
    resources :workspaces
    resources :clients
    resources :people
    resources :workspace_memberships
    resources :room_ownerships
    resources :rooms

    root to: 'workspaces#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :workspaces do
    resources :rooms, only: %i[show edit update] do
      resource :waiting_room, only: %i[show update]
      namespace :furniture do
        resources :tables, only: [:show], controller: 'breakout_tables/'
      end
    end
  end

  resources :guides, only: %i[index show]

  constraints BrandedDomain.new(Workspace) do
    root 'workspaces#show'
    get '/:id', to: 'rooms#show'
  end
end
