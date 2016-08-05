# Pseudocode for Scout

# Google Maps  - AIzaSyCrlW5ZaUO2TYOUNbSoFLaNVRrbusorJLw
# Zillow - X1-ZWz19muc0cecy3_4eq90
#things to add to the Location model, all can be floats
=begin
Area
zipcode
Bedrooms
Bathrooms
Sqft
Listing_price
Closing_price
Rental
price
rent
maintenance
tax_yr
Listing_type {live, sold, rental}
Zillow_page_link
Zillow_id
Commuter_hub {boolean}
# the below are calculated
Pricepersqft
Rentpersqft
taxpercent
######==========================
#    # Review Migration with Sol
######==========================

def fill_in_the_blanks (@location)
  if Zillow_id isnull
    Hit GetDeepSearch-Results API with address
    return Zillow_id
  end

  if sqft isnull
    Hit GetDeepSearch-Results API with address
    If that also null
      within Area
      calculate average sqft for #Bedrooms
    end
  end

  if rental isnull
    Hit GetDeepSearch-Results API with address
    If that also null
      within Area
      calculate average rent/sqft and * sqft
    end
  end

  if taxes isnull
    Hit GetDeepSearch-Results API with address
    If that also null
      within Area
      calculate average taxpercent * Listing_price
    end
  end
end
######==========================
#    # Review location.rb with Sol
######==========================


##==============================================
# Take the locations gathered, and check if they are deals

# Establish Variables

caprate = 10%
target_price = 0
@location

def find_deals(location.all)
  for each location
    calculate_price
    if target_price < Listing_price
      AND if Listing_type == live
        deal == true
      end
    end
  end
  return deals #as a location object
end

def calculate_price(@location)
  if rent, tax_yr, maintenance == 0; throw an exception
  else

  target_price = ((rent*12)-tax_yr-(maintenance*12))/caprate
  return target_price
end
=end
#========================================
# Gather properties to screen
# Gem Rubillow? May not be well maintained


def gather_properties (Target_zipcode OR Area)
  if Target_zipcode isnull
    Look up Area to get zipcodes
  end

  for each zipcode
    Use GetSearchResults API
    Call with zipcode
    Get lat, long
    Get LastSoldPrice, LastSoldDate, Zestimate
  end

  return array of properties as Locations
end

#================================
# Views

Select or enter Area
Put results of find_deals on a map
