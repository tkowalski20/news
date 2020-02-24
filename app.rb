require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "aed7bf60eae0b7e746870f1d1d664482"

# news API information
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=059e16ce361347e4ac13301d5837d288"
@news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output

#pp news


get "/" do
  # show a view that asks for the location

  view "ask"


end

get "/news" do
  # do everything else


  
  results = Geocoder.search(params["location"])
  lat_long = results.first.coordinates
  @lat = lat_long[0]
  @long = lat_long[1]

  @location = params["location"]

  @forecast = ForecastIO.forecast(@lat,@long).to_hash
  @current_temp =  @forecast["currently"]["temperature"]
  @current_weather = @forecast["currently"]["summary"]

  @current_summary = @forecast["daily"]["summary"]

  @today_weather = @forecast["daily"]["data"][0]["summary"]
  @today_high = @forecast["daily"]["data"][0]["temperatureHigh"]
  @today_low = @forecast["daily"]["data"][0]["temperatureLow"]
  @tomorrow_weather = @forecast["daily"]["data"][1]["summary"]
  @tomorrow_high = @forecast["daily"]["data"][1]["temperatureHigh"]
  @tomorrow_low = @forecast["daily"]["data"][1]["temperatureLow"]

  url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=059e16ce361347e4ac13301d5837d288"
  @news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output



  view "news"
end