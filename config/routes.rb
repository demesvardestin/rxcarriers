Rails.application.routes.draw do
  
  get 'invoice/create'

  devise_for :pharmacies, :controllers => {:registrations => "pharmacy/registrations"}
  devise_for :drivers, :controllers => { :registrations => "driver/registrations"}
  get 'cancellation_message/create'

  get 'request_message/create'

  get 'patients/create'

  get 'batch/new', to: 'batches#new'

  get 'batch/create'

  get 'batch/destroy'
  get 'cancel-request', to: 'requests#cancel'
  get 'settings', to: 'pharmacies#edit'
  get 'settings/advanced', to: 'pharmacies#edit'
  get 'settings/password', to: 'pharmacies#edit'
  get 'settings/account-info', to: 'pharmacies#edit'
  get 'settings/billing-info', to: 'pharmacies#edit'
  get 'pharmacy/search', to: 'pharmacies#index'
  get 'pharmacy/:id/settings', to: 'pharmacies#edit', as: "account_settings"
  get 'transactions', to: 'invoices#index'
  get 'users/auth/stripe_connect/callback', to: 'charges#stripe'
  get 'requests/:id', to: 'requests#show'
  get 'requests', to: 'requests#index'
  get 'request_driver', to: 'batches#request_driver'
  get 'batches', to: 'batches#index'
  get 'my-earnings', to: 'drivers#transactions'
  get 'home', to: 'drivers#show'
  get 'my-deliveries', to: 'drivers#deliveries'
  get 'pharmacy/view', to: 'pharmacies#index'
  post 'welcome/sms/reply', to: 'batches#driver_response'
  resources :charges
  resources :drivers
  resources :pharmacies do
    
  end
  resources :batches do
    resources :patients
  end
  resources :cancellation_messages
  resources :request_messages
  authenticated :driver do
    root 'drivers#deliveries', as: :authenticated_driver_root
  end
  authenticated :pharmacy do
    root 'batches#index', as: :authenticated_pharmacy_root
  end
  root 'pharmacies#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
