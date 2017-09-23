class ApplicationController < ActionController::API
  def home
    render json: {}
  end

  def ping
    ip = request.remote_ip

    url = "#{ENV['CLOUDFLARE_API_BASE_URL']}/zones/#{ENV['CLOUDFLARE_ZONE_ID']}/dns_records/#{ENV['CLOUDFLARE_DNS_ID']}"
    body = {
      type: ENV['CLOUDFLARE_DNS_TYPE'],
      name: ENV['CLOUDFLARE_DNS_NAME'],
      content: ENV['RACK_ENV'] != 'production' ? "172.217.11.174" : "#{ip}",
      proxied: true
    }.to_json
    headers = {
      'X-Auth-Email': ENV['CLOUDFLARE_EMAIL'],
      'X-Auth-Key': ENV['CLOUDFLARE_API_TOKEN'],
      'Content-Type': 'application/json'
    }

    result = HTTParty.put(url, body: body, headers: headers)

    result.parsed_response.to_json
  end
end
