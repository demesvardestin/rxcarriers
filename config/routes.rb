Rails.application.routes.draw do

  namespace :admin do
    resources :shoppers
    resources :pharmacies
    resources :batches
    resources :carts
    resources :deliveries
    resources :delivery_hours
    resources :inventories
    resources :invoices
    resources :items
    resources :item_categories
    resources :notifications
    resources :orders
    resources :refunds
    resources :request_alerts
    resources :reviews
    resources :rxes
    resources :sendgrid_emails
    resources :stripe_plans
    resources :terms_and_agreements
    resources :twilio_patients
    resources :users

    root to: "pharmacies#pharmacies"
  end

  devise_for :shoppers
  devise_for :customers
  # devise controller path
  devise_for :pharmacies, :controllers => {:registrations => "pharmacy/registrations"}
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
  get '/pharmacy/update_card', to: 'pharmacies#update_card'
  get '/pharmacy/add_card', to: 'pharmacies#add_card'
  get '/submit_agreement', to: 'pharmacies#submit_agreement'
  get 'deliveries/:id/signature', to: 'deliveries#signature'
  get 'settings', to: 'pharmacies#edit'
  get 'batch_search', to: 'batches#batch_search'
  get 'patient_search', to: 'patients#patient_search'
  get 'pharmacy/search', to: 'pharmacies#index'
  get 'pharmacy/:id/settings', to: 'pharmacies#edit', as: "account_settings"
  get '/payment-settings', to: 'invoices#index'
  get 'batches', to: 'batches#index'
  get 'not-found', to: 'drivers#not_found'
  get 'invoices/:id/delete', to: 'invoices#destroy'
  get 'transactions/:id', to: 'invoices#show'
  post '/create_batch', to: 'batches#create'
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
  get '/notifications', to: 'pharmacies#notifications'
  get '/fetch_notification', to: 'pharmacies#fetch_notification'
  get '/mark_read', to: 'pharmacies#mark_read'
  get '/dismiss_notification', to: 'deliveries#dismiss_notification'
  get '/dismiss_all_notifications', to: 'deliveries#dismiss_all_notifications'
  get 'update_profile', to: 'pharmacies#update_profile'
  get '/mark_picked', to: 'batches#mark_picked', as: 'mark_picked'
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
  get '/dashboard', to: 'pharmacies#dashboard'
  get '/update_rx_phone_number', to: 'deliveries#update_rx_phone_number'
  get '/live_requests_dashboard', to: 'deliveries#live_requests_dashboard'
  get '/set_invalid_rx', to: 'deliveries#set_invalid_rx'
  get '/update_rx_dob', to: 'deliveries#update_rx_dob'
  get '/update_rx_dob_pharmacy', to: 'deliveries#update_rx_dob_pharmacy'
  get '/delete_rx', to: 'deliveries#delete_rx'
  get '/get_all_notifications', to: 'deliveries#get_all_notifications'
  get '/send_patient_message', to: 'deliveries#send_patient_message'
  get '/bulk_calling', to: 'deliveries#bulk_calling'
  get '/bulk_texting', to: 'deliveries#bulk_texting'
  post '/call/:text', to: 'deliveries#call'
  get '/choose_subscription', to: 'deliveries#choose_subscription'
  get '/add_plan', to: 'deliveries#add_plan'
  post '/stripe_notification', to: 'deliveries#stripe_notification'
  get '/contact', to: 'pharmacies#contact'
  get '/legal/terms', to: 'pharmacies#terms'
  get '/legal/privacy', to: 'pharmacies#privacy'
  get '/legal/press', to: 'pharmacies#press'
  get '/check_rx_exist', to: 'deliveries#check_rx_exist'
  get '/cancel_subscription', to: 'pharmacies#cancel_subscription'
  get '/update_first_time', to: 'pharmacies#update_first_time'
  get '/pharmacy_search', to: 'pharmacies#search_pharmacy'
  get '/search', to: 'pharmacies#search'
  get '/pharmacies/:name/:id', to: 'pharmacies#show'
  get '/bag-history', to: 'batches#history'
  get '/bags', to: 'batches#index'
  get '/get_quote', to: 'batches#get_quote'
  get '/request_courier', to: 'batches#request_courier'
  get '/remove_rx', to: 'batches#remove_rx'
  post '/delivery', to: 'batches#delivery'
  get '/delivery_update', to: 'batches#delivery_update'
  post '/test', to: 'batches#test_'
  get '/cancel_courier_request', to: 'batches#cancel_courier_request'
  post '/order_prescriptions', to: 'rxes#order_prescriptions'
  post '/reviews', to: 'pharmacies#create_review'
  post '/add_item_to_cart', to: 'carts#add_item'
  post '/remove_item_from_cart', to: 'carts#remove_item'
  post '/clear_cart', to: 'carts#clear_cart'
  get '/submit_order', to: 'carts#process_payment'
  get '/checkout', to: 'carts#show'
  get '/order_queue', to: 'pharmacies#queue'
  get '/inventory', to: 'pharmacies#inventory'
  post '/items', to: 'pharmacies#create_item'
  patch '/items/:id', to: 'pharmacies#update_item'
  get '/expiring_soon', to: 'pharmacies#expiring_soon'
  get '/remove_filters', to: 'pharmacies#remove_filters'
  get '/low_available_count', to: 'pharmacies#low_available_count'
  get '/search_item', to: 'pharmacies#search_item'
  get '/validate_presence', to: 'pharmacies#validate_presence'
  get '/remove_item', to: 'pharmacies#remove_item'
  get '/reg_a_pharma', to: 'pharmacies#reg_a_pharma', as: 'register'
  get '/calculate_tip', to: 'carts#calculate_tip'
  get '/confirmation', to: 'carts#confirmation'
  get '/track_order', to: 'carts#track_order_status'
  get '/analytics', to: 'pharmacies#analytics'
  get '/analytics_weekly', to: 'pharmacies#analytics_weekly'
  get '/analytics_monthly', to: 'pharmacies#analytics_monthly'
  get '/analytics_annually', to: 'pharmacies#analytics_annually'
  get '/analytics_overall', to: 'pharmacies#analytics_overall'
  get '/process_order', to: 'pharmacies#process_order'
  get '/cancel_order', to: 'pharmacies#cancel_order'
  get '/send_for_delivery', to: 'pharmacies#send_for_delivery'
  get '/post_new_order', to: 'pharmacies#post_new_order'
  get '/in-store', to: 'pharmacies#in_store'
  get '/initiate_in_store_sale', to: 'carts#initiate_in_store_sale'
  get '/register-a-pharmacy', to: 'pharmacies#register_your_pharmacy'
  post '/registration_requests', to: 'pharmacies#submit_registration_request'
  get '/getting_started', to: 'pharmacies#getting_started'
  
  # resource path
  resources :invoices, only: [:create, :show, :index, :destroy]
  resources :batches
  resources :reviews, only: [:create, :index]
  resources :items
  resources :rxes, only: [:create, :index]
  resources :pharmacies
  resources :deliveries, only: [:create, :show, :edit, :update, :destroy]
  resources :help_tickets, only: [:index, :create]
  
  # authenticated devise models root path
  authenticated :pharmacy do
    root 'pharmacies#dashboard', as: :authenticated_pharmacy_root
  end
  
  # root path
  root 'pharmacies#landing'
  
end
