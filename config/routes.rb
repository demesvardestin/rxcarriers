Rails.application.routes.draw do
  

  # devise controller path
  devise_for :pharmacies, :controllers => {:registrations => "pharmacy/registrations"}
  devise_for :drivers, :controllers => { :registrations => "driver/registrations"}
  devise_scope :pharmacy do
    get 'login', to: 'devise/sessions#new'
    get 'signup', to: 'devise/registrations#new'
  end
  
  # custom path
  get 'update_card', to: 'pharmacies#update_card'
  get 'help', to: 'supports#new'
  get 'payment', to: 'drivers#payments'
  get 'first_time_edit', to: 'drivers#first_time', as: 'complete_profile'
  get 'driver-approved', to: 'supports#settings'
  get 'welcome', to: 'supports#onboarding_home'
  get 'deliveries/:id/signature', to: 'deliveries#signature'
  get 'cancel-request', to: 'requests#cancel'
  get 'driver/deliveries', to: 'drivers#requests', as: 'my-deliveries'
  get 'delivery-history', to: 'drivers#history'
  get 'settings', to: 'pharmacies#edit'
  get 'clock_in', to: 'drivers#clock_in'
  get 'clock_out', to: 'drivers#clock_out'
  get 'routes/:id', to: 'drivers#deliveries', as: 'routes'
  get 'payout/:id', to: 'drivers#payouts', as:'payout'
  get 'driver/:id/settings', to: 'drivers#edit'
  get 'driver/:id/settings/car-info', to: 'drivers#edit'
  get 'driver/:id/settings/bank-acct-info', to: 'drivers#edit'
  get 'driver/:id/settings/account-info', to: 'drivers#edit'
  get 'driver/:id/settings/advanced', to: 'drivers#edit'
  get 'settings/advanced', to: 'pharmacies#edit'
  get 'settings/password', to: 'pharmacies#edit'
  get 'settings/account-info', to: 'pharmacies#edit'
  get 'settings/billing-info', to: 'pharmacies#edit', as: 'pharmacy_billing'
  get 'batches/packages', to: 'batches#index'
  get 'batches/pharmacist', to: 'batches#index'
  get 'batches/pending', to: 'batches#index'
  get 'batches/accepted', to: 'batches#index'
  get 'batches/completed', to: 'batches#index'
  get 'batch_search', to: 'batches#index'
  get 'patient/search', to: 'patients#index'
  get 'request/search', to: 'requests#index'
  get 'pharmacy/search', to: 'pharmacies#index'
  get 'pharmacy/:id/settings', to: 'pharmacies#edit', as: "account_settings"
  get 'transactions', to: 'invoices#index'
  get 'users/auth/stripe_connect/callback', to: 'charges#stripe'
  get 'patients', to: 'patients#index'
  get 'request_driver', to: 'batches#request_driver'
  get 'batches', to: 'batches#index'
  get 'my-earnings', to: 'drivers#transactions'
  get 'home', to: 'drivers#show'
  get 'my-deliveries', to: 'drivers#deliveries'
  get 'pharmacy/view', to: 'pharmacies#index'
  post 'welcome/sms/reply', to: 'batches#driver_response'
  get 'not-found', to: 'supports#not_found', as: 'unauthorized'
  get 'invoices/:id/delete', to: 'invoices#destroy'
  get 'transactions/:id', to: 'invoices#show'
  
  # resource path
  resources :invoices, only: [:create, :show, :index, :destroy]
  resources :patients, only: [:create, :show, :edit, :update, :index, :new]
  resources :supports, only: [:new, :create, :show, :index]
  resources :charges
  resources :drivers
  resources :pharmacies
  resources :deliveries, only: [:create, :show, :edit, :update, :destroy]
  resources :batches do
    resources :deliveries, only: [:create, :show, :edit, :update, :destroy]
  end
  
  # authenticated devise models root path
  authenticated :driver do
    root 'drivers#requests', as: :authenticated_driver_root
  end
  authenticated :pharmacy do
    root 'batches#index', as: :authenticated_pharmacy_root
  end
  
  # root path
  root 'supports#home'
  
end
