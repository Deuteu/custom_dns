class TgUser < ApplicationRecord
  def to_s
    "Username: #{username}, TelegramId: #{telegram_id}"
  end
end
