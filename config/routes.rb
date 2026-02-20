Rails.application.routes.draw do
  # Main pages
  root "pages#home"

  get "/work",       to: "pages#work",       as: :work
  get "/about",      to: "pages#about",      as: :about
  get "/contact",    to: "pages#contact",    as: :contact
  get "/automation", to: "pages#automation", as: :automation
  get "/demo",       to: "pages#demo",       as: :demo

  # Case studies (individual project detail pages)
  resources :case_studies, only: [:show], path: 'work'

  # Contact form submission
  post "/contact", to: "contacts#create", as: :create_contact

  # Booking system
  get "/book-call", to: "bookings#new", as: :book_call

  resources :bookings, only: [:create, :show], param: :confirmation_token do
    collection do
      get :available_slots
      get :calendar_days
    end
    member do
      delete :cancel
    end
  end

  # Keep legacy projects routes for backward compatibility (optional)
  resources :projects, only: [:index, :show]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/up", to: proc { [200, { "Content-Type" => "text/plain" }, ["ok"]] }

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
