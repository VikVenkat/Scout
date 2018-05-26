require 'redis'

#REDIS = Redis.connect(url: "redis://127.0.0.1:6379/0")

Geocoder.configure(
:lookup => :google,
:use_https => true
# :cache => Redis.new,
# :always_raise => [
#   Geocoder::OverQueryLimitError,
#   Geocoder::RequestDenied,
#   Geocoder::InvalidRequest,
#   Geocoder::InvalidApiKey
# ]
#:api_key=> "#{GMAPS}"
)
