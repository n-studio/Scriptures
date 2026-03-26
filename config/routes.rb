Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Browse traditions and corpora
  resources :traditions, only: [ :index, :show ] do
    resources :corpora, only: [ :show ], param: :slug
  end

  # Search
  get "search", to: "search#index", as: :search

  # Canonical passage URLs: /bible/genesis/1
  get ":corpus_slug/:scripture_slug/:division_number", to: "passages#show", as: :reading

  # Root: show the default reading view (Genesis 1)
  root "passages#show"
end
