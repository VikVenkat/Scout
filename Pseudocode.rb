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

 Catch the ones that are not real locations
  - Do this in Ruby, not in DB checks (In progress...)
  - Create an array of location objects (works!)
  - Fill in required info on these locations (In Progress)
  - Delete elements of array missing data - ie. list price
  - Check how many elements are left
  - If not enough, change increment and repeat
   - Check for unique elements using array.unique or array.unique!
  - Save array elements to the db

Evaluate if deal
  - Calculate cap rate
  - Evaluate cap rate vs target (ie. 10%)

Show deals on map
