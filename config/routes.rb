Rails.application.routes.draw do
  root to: 'check_postcode#index'
  get 'check_postcode', to: 'check_postcode#index'
  post 'check_postcode', to: 'check_postcode#check'
end
