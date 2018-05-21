Rails.application.routes.draw do
  

  # devise controller path
  devise_for :pharmacies, :controllers => {:registrations => "pharmacy/registrations"}
  devise_for :drivers, :controllers => {:registrations => "driver/registrations"}
  devise_scope :driver do
    get 'courier/login', to: 'devise/sessions#new'
    get 'courier/signup', to: 'devise/registrations#new'
  end
  devise_scope :pharmacy do
    get 'pharmacy/login', to: 'devise/sessions#new'
    get 'pharmacy/signup', to: 'devise/registrations#new'
  end
  
  
  get '/courier/profile', to: 'drivers#show'
  get '/update_courier_bank', to: 'drivers#update_courier_bank'
  get '/update_courier', to: 'drivers#update_courier'
  get '/courier/deliveries', to: 'drivers#deliveries'
  get '/courier/deliveries/:id', to: 'deliveries#show'
  get '/courier/earnings', to: 'drivers#earnings'
  get '/unauthorized', to: 'drivers#unauthorized'
  get '/download_signature', to: 'deliveries#download_signature'
  get '/onboarding/address', to: 'drivers#onboarding_address'
  get '/onboarding/agreements', to: 'drivers#onboarding_agreement'
  get '/fetch_driver/:driver_id/:batch_id', to: 'drivers#fetch_driver'
  
  # custom path
  get 'pharmacy/update_card', to: 'pharmacies#update_card'
  get 'deliveries/:id/signature', to: 'deliveries#signature'
  get 'settings', to: 'pharmacies#edit'
  get 'batch_search', to: 'batches#batch_search'
  get 'patient_search', to: 'patients#patient_search'
  get 'pharmacy/search', to: 'pharmacies#index'
  get 'pharmacy/:id/settings', to: 'pharmacies#edit', as: "account_settings"
  get 'transactions', to: 'invoices#index'
  get 'batches', to: 'batches#index'
  get 'not-found', to: 'drivers#not_found'
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
  get '/notifications', to: 'batches#notifications'
  get '/notifications/mark_as_read', to: 'batches#clear_notifications'
  get '/dismiss_notification', to: 'batches#dismiss_notification'
  get 'update_profile', to: 'pharmacies#update_profile'
  get '/mark_picked', to: 'batches#mark_picked'
  get '/cancel_request', to: 'batches#cancel_request'
  get '/store_push_endpoint', to: 'drivers#store_push_endpoint'
  get '/store_pharma_push_endpoint', to: 'pharmacies#store_push_endpoint'
  get '/push', to: 'drivers#send_push'
  get '/unsubscribe', to: 'drivers#unsubscribe'
  get '/accept_request', to: 'drivers#accept_request'
  get '/unavailable_request', to: 'drivers#unavailable_request'
  get '/push_to_pharmacy', to: 'batches#notifications'
  get '/rx', to: 'deliveries#index'
  get '/status', to: 'deliveries#status'
  get '/search_my_rx', to: 'deliveries#rx_status'
  get '/get_pharmacy', to: 'deliveries#get_pharmacy'
  get '/request_delivery', to: 'deliveries#request_delivery'
  get '/update_rx_status', to: 'deliveries#update_rx_status'
  get '/rx_search', to: 'deliveries#rx_search'
  get '/add_new_rx', to: 'deliveries#add_new_rx'
  get '/dashboard', to: 'deliveries#dashboard'
  get '/update_rx_phone_number', to: 'deliveries#update_rx_phone_number'
  
  # resource path
  resources :invoices, only: [:create, :show, :index, :destroy]
  resources :patients
  resources :drivers
  resources :pharmacies
  resources :deliveries, only: [:create, :show, :edit, :update, :destroy]
  resources :batches do
    resources :deliveries, only: [:create, :show, :edit, :update, :destroy]
  end
  
  # authenticated devise models root path
  authenticated :driver do
    root 'drivers#deliveries', as: :authenticated_driver_root
  end
  authenticated :pharmacy do
    root 'batches#index', as: :authenticated_pharmacy_root
  end
  
  # root path
  root 'batches#home'
  
end
