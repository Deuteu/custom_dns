class TelegramController < ApplicationController
  def webhook
    unless params[:token] ==  ENV['TG_WEBHOOK_TOKEN']
      render status: :ok, nothing: true
      return
    end

    unless params[:message]
      puts "MissingArgs - No message: #{params}"
      render status: :ok, json: {}
      return
    end

    message = params[:message]
    unless message["chat"] && message["chat"]["id"]
      puts "MissingArgs - No chat id for response: #{params}"
      render status: :ok, json: {}
      return
    end
    chat_id = message["chat"]["id"]

    from = message["from"]
    unless is_admin?(from["id"])
      puts "NotAdmin - Message by not admin user: #{from}"
      api.sendMessage(message["chat"]["id"], "My mum told me not to talk to stranger.")
      render status: :ok, json: {}
      return
    end

    unless message["text"]
      puts "EmptyMessage - Message with no text: #{message}"
      render status: :ok, json: {}
      return
    end

    puts "Message: #{message}"

    # Return an empty json, to say "ok" to Telegram
    render status: :ok, json: {}
  end

  private
  def is_admin?(user_id)
    admin_ids = ENV['TG_ADMIN_IDS'].to_s.split(';')
    admin_ids << ENV['TG_SUPER_ADMIN_ID'].to_s
    return admin_ids.include?(user_id.to_s)
  end
end
