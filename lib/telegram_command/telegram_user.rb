class TelegramCommand
  class TelegramUser < AbstractTelegramCommand
    def self.command
      'user'
    end

    class SuperAdmin < AbstractTelegramCommand
      def self.command
        'super'
      end

      def self.exec(_args = [], _options = {})
        'Dt'
      end
    end
  end
end
