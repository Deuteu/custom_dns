class TelegramCommand
  class TelegramUser < AbstractTelegramCommand
    class << self
      def command
        'user'
      end
    end

    class SuperAdmin < AbstractTelegramCommand
      class << self
        def command
          'super'
        end

        def exec(_args = [], _options = {})
          'Dt'
        end
      end
    end

    class List < AbstractTelegramCommand
      class << self
        def command
          'list'
        end

        def exec(args = [], _options = {})
          limit = 5
          if args.first
            limit_arg = args.first.to_i
            limit = limit_arg > 0 && limit_arg < 10 ? limit_arg : limit
          end

          page_count = TgUser.page(1).per(limit).total_pages
          page = 1
          if args.second
            page_arg = args.second.to_i
            page = page_arg > 0 && page_arg <= page_count ? page_arg : page
          end

          result = "User list #{page}/#{page_count}"

          TgUser.page(page).per(limit).each do |user|
            result += "\n- #{user.to_s}"
          end

          result
        end
      end
    end
  end
end
