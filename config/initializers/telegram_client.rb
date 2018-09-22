Telegram.configure do |c|
  c.admin_ids      = ENV['TG_ADMIN_IDS'].to_s.split(';')
  c.api_token      = ENV['TG_API_TOKEN'].to_s
  c.super_admin_id = ENV['TG_SUPER_ADMIN_ID'].to_s.presence
  c.webhook_token  = ENV['TG_WEBHOOK_TOKEN']
end

unless defined?(Rails::Console) || defined?(Rails::Generators) || File.basename($0) == 'rake'
  # To enable dyno metadata
  # > heroku labs:enable runtime-dyno-metadata -a <app name>
  # https://devcenter.heroku.com/articles/dyno-metadata
  if (app_name = ENV['HEROKU_APP_NAME'].to_s.presence)
    wh_base_url   = "https://#{app_name}.herokuapp.com"
    response      = Telegram.client.setWebhook("#{wh_base_url}/#{Telegram.webhook_token}").to_json
    text_response = "Webhook set on '#{wh_base_url}': #{response}"
    Telegram.client.sendMessage(Telegram.super_admin_id, text_response) if Telegram.super_admin_id
    puts text_response
  end
end
