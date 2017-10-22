require 'socket'
require 'httparty'

class Bob
  include HTTParty

  IP_API = 'http://ip-api.com/json/'
  WEATHER_API = 'http://api.openweathermap.org/data/2.5/weather?'
  API_KEY= '&APPID='
  METRIC_UNITS = '&units=metric'

  attr_reader :ip_information, :weather

  def initialize
    @ip_information = tell_ip
    @weather = set_weather
  end

  def tell_ip
    JSON.parse(HTTParty.get("http://ip-api.com/json/").body)
  end

  def set_weather
    get_weather_from_api
  end

  def tell_lat_long
    "lat=#{@ip_information['lat']}&lon=#{@ip_information['lon']}"
  end

  def get_weather_from_api
    JSON.parse(HTTParty.get(WEATHER_API + tell_lat_long + API_KEY + METRIC_UNITS).body)
  end
end

class Weather

  def initialize
    @weather_info = Bob.new
  end

  def current
    puts "#{@weather_info.ip_information['city']} #{@weather_info.ip_information['country_code']} #{@weather_info.ip_information['country']}"
    puts "Current Temp: #{@weather_info.weather.dig('main', 'temp')}"
  end

end
