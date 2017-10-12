class AbstractTelegramCommand
  def self.command
    (self.name.split('::').last || self.name).underscore
  end

  class << self; attr_accessor :sub_commands end
  def self.sub_commands
    @sub_commands ||= self.constants.inject({}) do |hash, c|
      const = self.const_get(c)
      if const.is_a?(Class) && const < AbstractTelegramCommand
        command              = const.command
        hash[command.to_sym] = const
      end
      hash
    end
  end

  def self.exec(args = [], options = {})
    if self.sub_commands.blank?
      'Unimplemented command'
    else
      sub = args.shift
      if sub
        sub.downcase!
        cmd = @sub_commands[sub.to_sym]
        if cmd
          cmd.exec(args, options)
        else
          "Unknown subcommand: #{sub}"
        end
      else
        "Available subcommands: #{sub_commands.keys.join(',')}"
      end
    end
  end
end

class TelegramCommand < AbstractTelegramCommand
  def self.exec(args = [], options = {})
    if self.sub_commands.blank?
      'Nothing to do here. Sorry.'
    else
      sub = args.shift
      if sub
        sub.downcase!
        cmd = @sub_commands[sub.to_sym]
        if cmd
          return cmd.exec(args, options)
        end
      end
      "Available commands: #{sub_commands.keys.join(',')}"
    end
  end
end

Dir[Rails.root.join('lib', 'telegram_command', '*')].each {|file| require file }
