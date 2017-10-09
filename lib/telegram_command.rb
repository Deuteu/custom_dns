module TelegramCommand
end

class TelegramCommandStub
  def self.command
    (self.name.split('::').last || self.name).underscore
  end

  class << self; attr_accessor :sub_commands end
  def self.sub_commands
    @sub_commands ||= self.constants.inject({}) do |hash, c|
      const = self.const_get(c)
      if const.is_a?(Class) && const < TelegramCommandStub
        command              = const.command
        hash[command.to_sym] = const
      end
      hash
    end
  end

  def self.exec(args = [])
    if self.sub_commands.blank?
      'Unimplemented command'
    else
      sub = args.shift
      if sub && @sub_commands[sub.to_sym]
        @sub_commands[sub.to_sym].exec(args)
      else
        "Subcommands: #{sub_commands.keys.join(',')}"
      end
    end
  end
end

Dir[Rails.root.join('lib', 'telegram_command', '*')].each {|file| require file }
