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

    class SuperAdmin < AbstractTelegramCommand
      def self.command
        'list'
      end

      def self.exec(args = [], _options = {})
        limit = 5
        if args.first
          limit_arg = args.first.to_i
          limit = limit_arg > 0 && limit_arg < 10 ? limit_arg : limit
        end

        page = 1
        if args.second
          page_arg = args.second.to_i
          page = page_arg > 0 ? page_arg : page
        end

        page_count = TgUser.page(page).per(limit).total_pages
        result = "User list #{page}/#{page_count}"

        TgUser.page(page).per(limit).each do |user|
          result += "\n- #{user.to_s}"
        end

        result
      end
    end
  end
end
