class TargetLocationList #This is the part referenced in the model
  require 'uri' #This library allows us to do URL string encoding like below
  require 'geocoder'


  def initialize(target, increment)
    @target = target
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
    @filled_array = Array.new

    basic_locations.each do |loc|
      @addy = AddressInformation.new(loc)
        loc.update_attributes(:zillow_id => @addy.fields[:zillow_id])
        loc.update_attributes(:sqft => @addy.fields[:sqft])
        loc.update_attributes(:rent_price => @addy.fields[:rent_price])
        loc.update_attributes(:list_price => @addy.fields[:list_price])
        loc.update_attributes(:beds => @addy.fields[:beds])
        loc.update_attributes(:baths => @addy.fields[:baths])
        loc.update_attributes(:zillow_page_link => @addy.fields[:zillow_page_link])

#      @taxy = TaxInformation.new(loc)
#      loc.update_attributes(:taxes_annual => @taxy.fields[:taxes_annual] )
        #Zillow seems to have discontinued the API i used here

      @filled_array.push(loc)
      #Learning note. When I was using @location_array in this step, why did it create an infinite loop
      puts loc[:address]

    end #do

    return @filled_array #works
  end #filled_locations

  def calculated_locations
    @calc_array = Array.new

    filled_locations.each do |loc|
      begin

        loc.update_attributes(:price_per_sqft => loc.list_price / loc.sqft)

        if loc.rent_price == 0
          @a = Array.new
          @a = Location.where(beds: loc.beds, zipcode: loc.zipcode, rent_price > 0) # select existing records from the same town with the same # bedrooms
          @b = @a.average("rent_price") 
          binding.pry
        end #if
        loc.update_attributes(:rent_per_sqft => loc.rent_price / loc.sqft)
        #loc.update_attributes(:taxpercent => loc.taxes_annual / loc.list_price)
      rescue TypeError
        Rails.logger.error { "Encountered a TypeError error in Calculating KPIs. Check values: SQFT: #{loc.sqft}; $List: #{loc.list_price}" }
        # flash[:alert] = "Encountered a TypeError error in Calculating KPIs. Check values: SQFT: #{loc.sqft}; $List: #{loc.list_price}"
      rescue => e
        Rails.logger.error { "Encountered an #{e.message} in Calculating KPIs"}
        # flash[:alert] = "Encountered an #{e.message} in Calculating KPIs"
      end #begin
    end #do
  end #calculated_locations
end
