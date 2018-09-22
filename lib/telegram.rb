module Telegram
  class << self
    def configuration
      Configuration.instance
    end

    delegate :admin_ids, :api_token, :super_admin_id, :webhook_token, to: :configuration

    def admin?(user_id)
      @all_admin_ids.include?(user_id.to_i)
    end

    def client
      @client ||= TelegramAPI.new(api_token)
    end

    def configure
      yield(configuration)
    end

    def reload_client
      @client = TelegramAPI.new(api_token)
    end

    def reload_admins
      @all_admin_ids = admin_ids
      @all_admin_ids << super_admin_id if super_admin_id
      @all_admin_ids
    end
  end

  class Configuration
    include Singleton

    attr_writer :webhook_token

    attr_reader :api_token,
                :super_admin_id,
                :webhook_token

    def admin_ids
      @admin_ids || []
    end

    def admin_ids=(val)
      array = val || []
      array.each_with_object([]) do |id, a|
        a << id.to_i if id
      end

      @admin_ids = array
      Telegram.reload_admins
    end

    def api_token=(val)
      @api_token = val
      Telegram.reload_client
      @api_token
    end

    def super_admin_id=(val)
      @super_admin_id = val.presence && val.to_i # Nil if empty
      Telegram.reload_admins
      @super_admin_id
    end
  end
end
