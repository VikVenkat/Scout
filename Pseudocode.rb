# Pseudocode for Scout

Take in target area, eg. Perth Amboy Train Station
 - Search for the string (works!)
 - Confirm actual locations/geocode (works!)
 - Save this location as a target (works!)

Find nearby listings (maybe by town)
 - Given target lat/long (works!)
 - Create box of radius (ie. .5 mi) (works!)
 - Using Geocoder; Loop through all lat/long pairs within a bounding box (works!)
 - Check each of these addresses against Zillow (ie. turn into Locations) (works!)

Evaluate if deal
 - Calculate cap rate
 - Evaluate cap rate vs target (ie. 10%)

Show deals on map
