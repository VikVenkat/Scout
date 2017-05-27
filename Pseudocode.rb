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
  - Do this in Ruby, not in DB checks (works!)
  - Create an array of location objects (works!)
  - Fill in required info on these locations (works!)
    - Zillow has taken down their MonthlyPayments API...need a new way to estimate taxes (works, kind of)
  - Delete elements of array missing data - ie. list price (works!)
  - Check how many elements are left (works)
  - If not enough, change increment and repeat (WAITING for accuracy)
  - Unique elements using array.unique or array.unique!(works!)
  - Save array elements to the db (still happens by default)
  - Dedupe by ZillowID (works!)

Evaluate if deal
  - Calculate cap rate (works!)
  - Evaluate cap rate vs target (ie. 10) (WAITING for accuracy)

Fix erroneous list prices
 - Clean up some long functions (done)
 - Create new variable to hold actuals data(done)
 - Update codes to use new variable
 - Zestimate vs actual training set
 - Write training algorithm
 - Update better price estimates
 - Go back and fix WAIT items above

Fix other erroneous data
 - Missing bedrooms / bathrooms (done)
 - Get all the addresses when multiple are matched

Clean up flow
 - Get bootstrap gem
 - First, type in target
 - Search own DB before Zillow
 - Then show metrics
 - Show deals on map
 - Get to location table only by drill-down
