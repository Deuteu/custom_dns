class TelegramCommand
  class TelegramUser < AbstractTelegramCommand
    def self.command
      'user'
    end

    class SuperAdmin < AbstractTelegramCommand
      def self.command
        'super'
      end

      def self.exec
        'Dt'
      end
    end
  end
end
