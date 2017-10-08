desc 'This task is called by the Heroku scheduler add-on'
task jared: :environment do
  def ping_home
    t1 = Thread.new do
      Rails.logger.info "I'm awake! I'm awake."
      Net::HTTP.get_response(URI.parse("https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com"))
      Rails.logger.info "I'm sorry for sleeping and for lying about it."
    end
    t1.join
  end

  if ENV['HEROKU_APP_NAME'].to_s.blank?
    Rails.logger.info 'No Heroku app name'
  else
    ping_home
  end
end
