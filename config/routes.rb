Rails.application.routes.draw do
  scope nil, defaults: {format: :json} do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root 'application#home'

    # Legacy routes
    # to: redirect('/%{token}', status: 302)
    post '/:token', to: 'telegram#legacy_webhook'
    put  '/:token', to: 'application#legacy_ping'

    scope '/telegram', controller: :telegram do
      post '/:token', action: :webhook
    end

    scope '/dns', controller: :dns do
      put '/:token', action: :ping
    end
  end
end
