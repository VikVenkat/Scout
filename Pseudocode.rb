# Pseudocode for Scout

Take in target area, eg. Perth Amboy Train Station
 - Search for the string
 - Confirm actual locations/geocode
 - Save this location as a target

Find nearby listings (maybe by town)
 ? https://developer.homefinder.com/ (sent request)
 ? Using Geocoder; Loop through all lat/long pairs within a bounding box
 #
 reverse_geocoded_by :latitude, :longitude,
  :address => :location
after_validation :reverse_geocode

Filter by 10 minute walking distance (~833m @ 5kph)

Evaluate if deal
 - Get listing price
 - Estimate rent
 - Get taxes, maintenance
 - Calculate cap rate
 - Evaluate cap rate vs target (ie. 10%)

Show deals on map
