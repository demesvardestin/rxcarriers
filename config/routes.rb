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
  get 'batch_search', to: 'batches#batch_search'
  get 'patient_search', to: 'patients#patient_search'
  get 'request/search', to: 'requests#index'
  get 'pharmacy/search', to: 'pharmacies#index'
  get 'pharmacy/:id/settings', to: 'pharmacies#edit', as: "account_settings"
  get 'transactions', to: 'invoices#index'
  get 'users/auth/stripe_connect/callback', to: 'charges#stripe'
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
  get '/create_batch', to: 'batches#create_batch'
  get '/update_batch', to: 'batches#update_batch'
  get 'order_asc', to: 'batches#order_asc'
  get 'order_desc', to: 'batches#order_desc'
  get 'update_firebase', to: 'pharmacies#update_firebase'
  get '/customers', to: 'patients#all_patients'
  get '/customer', to: 'patients#show'
  get '/create_patient', to: 'patients#create_patient'
  get '/customer/:id/update_card', to: 'patients#update_card'
  get '/update_patient/:id', to: 'patients#update_patient'
  get 'live_search', to: 'patients#live_search'
  get '/create_deliveries', to: 'batches#create_deliveries'
  get '/remove_delivery', to: 'batches#delete_delivery'
  get '/get_delivery_details/:id', to: 'batches#get_delivery_details'
  get '/deliveries_today', to: 'batches#deliveries_today'
  get '/update_supervisor', to: 'batches#update_supervisor'
  
  # resource path
  resources :invoices, only: [:create, :show, :index, :destroy]
  resources :patients
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
