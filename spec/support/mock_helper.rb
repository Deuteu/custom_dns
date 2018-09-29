require 'webmock/rspec'

class TelegramAPI
  def self.core
    @@core
  end
end

module ApiMock
  class << self
    def whitelist
      WebMock.disable_net_connect!(allow_localhost: true)
    end

    def cloudflare(body_response = {})
      WebMock::API.
        stub_request(:put, %r{#{var_env_regex('CLOUDFLARE_API_BASE_URL')}/zones/[\da-z]+/dns_records/[\da-z]+}).
        to_return(status: 200, body: body_response.to_json, headers: {})
    end

    def telegram_client
      WebMock::API.
        stub_request(:post, %r{#{TelegramAPI.core}/*}).
        to_return(status: 200, body: {}.to_json, headers: {})
    end

    def var_env_regex(var)
      v    = ENV[var].try(:downcase) || ''
      uri  = (v.start_with?('http') ? URI.parse(v) : URI.parse("http://#{v}"))

      http_basic_auth = 'https?\:\/\/(.+\:.+\@)?'
      port = '\:\d+'
      host = uri.host
      path = uri.path

      "#{http_basic_auth}#{Regexp.quote(host || 'localhost')}(#{port})?#{path}"
    end
  end
end
