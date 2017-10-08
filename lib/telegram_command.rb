module TelegramCommand
end

Dir[Rails.root.join('lib', 'telegram_command', '*')].each {|file| require file }
