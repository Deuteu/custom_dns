if ENV['RACK_ENV'] != 'production'
  require 'dotenv/load'
end

require 'sinatra'

require 'json'
require 'httparty'

get "/#{ENV['PING_TOKEN']}" do
  ip = request.ip

  url = "#{ENV['CLOUDFLARE_API_BASE_URL']}/zones/#{ENV['CLOUDFLARE_ZONE_ID']}/dns_records/#{ENV['CLOUDFLARE_DNS_ID']}"
  puts url
  body = {
    type: ENV['CLOUDFLARE_DNS_TYPE'],
    name: ENV['CLOUDFLARE_DNS_NAME'],
    content: ENV['RACK_ENV'] != 'production' ? "172.217.11.174" : "#{ip}"
  }.to_json
  puts body
  headers = {
    'X-Auth-Email': ENV['CLOUDFLARE_EMAIL'],
    'X-Auth-Key': ENV['CLOUDFLARE_API_TOKEN'],
    'Content-Type': 'application/json'
  }
  result = HTTParty.put(url, body: body, headers: headers)

  result.parsed_response.to_json
end