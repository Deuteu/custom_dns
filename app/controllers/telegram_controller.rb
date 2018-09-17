require 'telegram_command'

class TelegramController < ApplicationController
  def webhook
    unless params[:token] == ENV['TG_WEBHOOK_TOKEN']
      render status: :ok, nothing: true
      return
    end

    unless params[:message]
      Rails.logger.info "MissingArgs - No message: #{params}"
      render status: :ok, json: {}
      return
    end
    message = params[:message]

    unless message['chat'] && message['chat']['id']
      Rails.logger.info "MissingArgs - No chat id for response: #{params}"
      render status: :ok, json: {}
      return
    end
    chat_id = message['chat']['id']

    from = message['from']
    unless admin?(from['id'])
      Rails.logger.info "NotAdmin - Message by not admin user: #{from}"
      TELEGRAM_CLIENT.sendMessage(chat_id, 'My mum told me not to talk to stranger.')
      render status: :ok, json: {}
      return
    end

    unless message['text']
      Rails.logger.info "EmptyMessage - Message with no text: #{message}"
      render status: :ok, json: {}
      return
    end

    Rails.logger.info "Message: #{message}"
    process_command(message)

    # Return an empty json, to say "ok" to Telegram
    render status: :ok, json: {}
  end

  private

  def admin?(user_id)
    admin_ids = ENV['TG_ADMIN_IDS'].to_s.split(';')
    admin_ids << ENV['TG_SUPER_ADMIN_ID'].to_s
    admin_ids.include?(user_id.to_s)
  end

  def process_command(tg_message)
    response = ::TelegramCommand.exec(tg_message['text'].split(' '))
    TELEGRAM_CLIENT.sendMessage(tg_message['chat']['id'], response)
  end
end
