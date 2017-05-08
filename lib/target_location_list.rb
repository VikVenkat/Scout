class TargetLocationList #This is the part referenced in the model
  require 'uri' #This library allows us to do URL string encoding like below
  require 'geocoder'


  def initialize(target, increment)
    @target = target
#    @lat = @target.latitude
#    @lon = @target.longitude
#    @radius = @target.radius #will be a distance in miles
    @n = @target.north
    @s = @target.south
    @e = @target.east
    @w = @target.west
    @increment = increment.to_f

  end #initialize

  def coord_array
    @starting_set = Array.new
    #increment = @increment
    lat_range = @s..@n
    long_range = @w..@e

    lat_range.step(@increment).each do |la|
      long_range.step(@increment).each do |lo|
        @starting_set << [la, lo]
      end
    end
#    binding.pry #this creates a breakpoint in the console, can use local variables, debug, etc

    return @starting_set
  end #coord_array


  def basic_locations

    @location_array = Array.new
    @search_result

    coord_array.each do |(x,y)| # update this to include the above
      loc = Location.new
      @search_result = Geocoder.search([x,y]).first
          loc.address = @search_result.street_number + " " + @search_result.route
          loc.city = @search_result.city
          loc.state = @search_result.state
          loc.zipcode = @search_result.postal_code
      @location_array.push(loc)

    end #do
#    binding.pry
    return @location_array #works!

  end #basic_locations

  def filled_locations
    @location_array = Array.new

    basic_locations.each do |loc|

      @addy = AddressInformation.new(loc)
      loc.update_attributes(:zillow_id => @addy.fields[:zillow_id])
      loc.update_attributes(:sqft => @addy.fields[:sqft])
      loc.update_attributes(:rent_price => @addy.fields[:rent_price])
      loc.update_attributes(:list_price => @addy.fields[:list_price])
      loc.update_attributes(:beds => @addy.fields[:beds])
      loc.update_attributes(:baths => @addy.fields[:baths])
      loc.update_attributes(:zillow_page_link => @addy.fields[:zillow_page_link])
      #works!
#      @taxy = TaxInformation.new(loc)
#      loc.update_attributes(:taxes_annual => @taxy.fields[:taxes_annual] )
        #Zillow seems to have discontinued the API i used here
#      @location_array.push(loc) #this is creating an infinite loop
      puts loc[:address]
    end #do
    binding.pry
    return @location_array
  end #filled_locations

end
