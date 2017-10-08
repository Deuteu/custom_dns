module TelegramCommand
end

class TelegramCommandStub
  def self.command
    (self.name.split('::').last || self.name).underscore
  end
end

Dir[Rails.root.join('lib', 'telegram_command', '*')].each {|file| require file }
