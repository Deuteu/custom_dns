require 'telegramAPI'

TELEGRAM_CLIENT = TelegramAPI.new(ENV['TG_API_TOKEN'].to_s)

# To enable dyno metadata
# > heroku labs:enable runtime-dyno-metadata -a <app name>
# https://devcenter.heroku.com/articles/dyno-metadata
unless ENV['HEROKU_APP_NAME'].nil?
  wh_base_url   = "https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com"
  response      = TELEGRAM_CLIENT.setWebhook("#{wh_base_url}/#{ENV['TG_WEBHOOK_TOKEN']}").to_json
  text_response = "Webhook set on '#{wh_base_url}': #{response}"
  TELEGRAM_CLIENT.sendMessage(ENV['TG_SUPER_ADMIN_ID'].to_s, text_response) unless ENV['TG_SUPER_ADMIN_ID'].nil?
  puts text_response
end
