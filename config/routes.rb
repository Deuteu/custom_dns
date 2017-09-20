Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#home'

  get ENV['TG_WEBHOOK_TOKEN'] || 'TG_WEBHOOK_TOKEN', to: 'telegram#webhook'
end
