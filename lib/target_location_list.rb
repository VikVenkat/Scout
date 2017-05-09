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

        if loc.sqft == 0
          @c = Array.new
          @c = Location.where('beds like ? AND city like ? AND sqft > ?', loc.beds, loc.city, 0) #gather up sqft of same beds in that city
          @avg_sqft = @c.average("sqft")
          loc.update_attributes(:sqft => @avg_sqft)
          loc.update_attributes(:sqft_type => false)
          binding.pry
        end #if sqft

        loc.update_attributes(:price_per_sqft => loc.list_price / loc.sqft)

        if loc.rent_price == 0
          @a = Array.new
          @a = Location.where('beds like ? AND zipcode like ? AND rent_price > ?',loc.beds, loc.zipcode, 0) # select existing records from the same town with the same # bedrooms
          @avg_rent = @a.average("rent_price")
          loc.update_attributes(:rent_price => @avg_rent)
          loc.update_attributes(:rent_price_type => false)
          binding.pry
        end #if rent
        loc.update_attributes(:rent_per_sqft => loc.rent_price / loc.sqft)

        if loc.taxes_annual == 0
          @b = Array.new
          @b = Location.where('city like ? AND taxes_annual > ? AND taxpercent > ? AND list_price > ?', loc.city, 0, 0, 0) #? AND taxes_annual_type = true #pull the % taxes for that City
          @avg_taxpct = @b.average("taxpercent")
          loc.update_attributes(:taxpercent => @avg_taxpct)
          loc.update_attributes(:taxes_annual => @avg_taxpct * loc.list_price)
          loc.update_attributes(:taxes_annual_type => false)
          binding.pry
        else
          loc.update_attributes(:taxpercent => loc.taxes_annual / loc.list_price)
        end # if taxes

        if loc.caprate == 0
          @a_rent = loc.rent_price *12
          @taxes = loc.taxes_annual
          @a_mnt = loc.maintenance*12
          @buffer = .9
          @numerator = (@a_rent - @taxes - @a_mnt)*@buffer

          loc.update_attributes(:caprate => @numerator/loc.list_price)
          binding.pry
        end #if caprate

      rescue TypeError
        Rails.logger.error { "Encountered a TypeError error in Calculating KPIs(targets). Check values: SQFT: #{loc.sqft}; $List: #{loc.list_price}; $Tax: #{loc.taxes_annual}" }
      rescue => e
        Rails.logger.error { "Encountered an #{e.message} in Calculating KPIs(targets)"}
      end #begin
    end #do
  end #calculated_locations
end
