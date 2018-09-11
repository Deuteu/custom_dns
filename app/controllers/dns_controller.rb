class DnsController < ApplicationController
  def legacy_ping
    Rails.logger.info('TelegramController#legacy_ping >> Deprecated use')
  end

  def ping
    unless params[:token] ==  ENV['PING_TOKEN']
      render status: :ok, nothing: true
      return
    end

    ip = request.remote_ip

    url = "#{ENV['CLOUDFLARE_API_BASE_URL']}/zones/#{ENV['CLOUDFLARE_ZONE_ID']}/dns_records/#{ENV['CLOUDFLARE_DNS_ID']}"
    body = {
        type: ENV['CLOUDFLARE_DNS_TYPE'],
        name: ENV['CLOUDFLARE_DNS_NAME'],
        content: ENV['RACK_ENV'] != 'production' ? '172.217.11.174' : "#{ip}",
        # proxied: true # Removed cause do not allow ssh access
    }.to_json
    headers = {
        'X-Auth-Email' => ENV['CLOUDFLARE_EMAIL'],
        'X-Auth-Key' => ENV['CLOUDFLARE_API_TOKEN'],
        'Content-Type' => 'application/json'
    }

    result = HTTParty.put(url, body: body, headers: headers)

    render status: :ok, json: result.parsed_response
  end
end