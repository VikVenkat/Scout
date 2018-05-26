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

  def cleanup!
    @cleanup_1 = Location.where(:address => "").destroy_all
    @cleanup_2 = Location.where(:list_price => 0).destroy_all
    puts "Cleaned up Locations!"
  end #cleanup

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
      sleep(0.1) #sleep for 100ms b/c Google geocoding api limits 50 calls/sec

    end #do
    # binding.pry # to check .uniq
    return @location_array.uniq #check this #seems to work

  end #basic_locations

  def filled_locations
    @filled_array = Array.new

    basic_locations.each do |loc|
      AddressInformation.new(loc).update_location
      # @addy.update_location
#        loc.update_attributes(:zillow_id => @addy.fields[:zillow_id])
#        loc.update_attributes(:sqft => @addy.fields[:sqft])
#        loc.update_attributes(:rent_price => @addy.fields[:rent_price])
#        loc.update_attributes(:list_price => @addy.fields[:list_price])
#        loc.update_attributes(:beds => @addy.fields[:beds])
#        loc.update_attributes(:baths => @addy.fields[:baths])
#        loc.update_attributes(:zillow_page_link => @addy.fields[:zillow_page_link])
#        loc.update_attributes(:address => @addy.fields[:address]) #sol this is not working

        # fields = @addy.fields
        # loc.zillow_id = fields[:zillow_id]
        # loc.sqft = fields[:sqft]
        # loc.rent_price = fields[:rent_price]
        # loc.list_price = fields[:list_price]
        # loc.beds = fields[:beds]
        # loc.baths = fields[:baths]
        # loc.zillow_page_link = fields[:zillow_page_link]
        # loc.address = fields[:address]


#      @taxy = TaxInformation.new(loc)
#      loc.update_attributes(:taxes_annual => @taxy.fields[:taxes_annual] )
        #Zillow seems to have discontinued the API i used here
        puts loc.address
        loc.save
      @filled_array.push(loc) unless loc.list_price == 0
#    binding.pry  #sol

    end #do
    # @filled_array.delete_if do |c|
    #   if c[:list_price] == 0
    #     true
    #   end #if
    # end #do
    return @filled_array #works
  end #filled_locations

  def calculated_locations
    @calc_array = Array.new
    cleanup!

    filled_locations.each do |loc|
      begin
        check_sqft(loc)
        check_rent(loc)
        check_taxes(loc)
        check_beds(loc)
        check_baths(loc)
      rescue TypeError
        Rails.logger.error { "Encountered a TypeError error in (calculated_locations). Check values: SQFT: #{loc.sqft}; $List: #{loc.list_price}; $Tax: #{loc.taxes_annual}" }
      rescue => e
        Rails.logger.error { "Encountered an #{e.message} in (calculated_locations)"}
      end #begin
#      binding.pry
      @calc_array.push(loc)
    end #do

    @calc_array.delete_if do |c|
      if c[:list_price] == 0
        true
      end #if
    end #do

    return @calc_array #works
  end #calculated_locations

  def caprate_locations
    @caprate_array = Array.new
    cleanup!

    calculated_locations.each do |loc|

      begin
        calc_cap(loc)
      rescue TypeError
        Rails.logger.error { "Encountered a TypeError error in (caprate_locations). Check values: SQFT: #{loc.sqft}; $List: #{loc.list_price}; $Tax: #{loc.taxes_annual}" }
      rescue => e
        Rails.logger.error { "Encountered an #{e.message} in (caprate_locations)"}
      end #begin
      @caprate_array.push(loc)
    end #do

    return @caprate_array #works, however, math is off b/c prices
  end #caprate_locations

 def check_sqft(loc)
   if loc.sqft == 0 || loc.sqft.nil?
     @c = Array.new
     @c = Location.where('beds like ? AND city like ? AND sqft > ?', loc.beds, loc.city, 0) #gather up sqft of same beds in that city
     @avg_sqft = @c.average("sqft").to_f
     loc.update_attributes(:sqft => @avg_sqft)
     loc.update_attributes(:sqft_type => false)

   else
     loc.update_attributes(:sqft_type => true)
   end #if sqft

   loc.update_attributes(:price_per_sqft => loc.list_price / loc.sqft)
 end #sqft

 def check_rent(loc)
   if loc.rent_price == 0 || loc.rent_price.nil?
     @a = Array.new
     @a = Location.where('beds like ? AND zipcode like ? AND rent_price > ?',loc.beds, loc.zipcode, 0) # select existing records from the same town with the same # bedrooms
     @avg_rent = @a.average("rent_price").to_f
     loc.update_attributes(:rent_price => @avg_rent)
     loc.update_attributes(:rent_price_type => false)

   else
     loc.update_attributes(:rent_price_type => true)
   end #if rent
   loc.update_attributes(:rent_per_sqft => loc.rent_price / loc.sqft)
 end #rent

 def check_taxes(loc)
   if loc.taxes_annual == 0 || loc.taxes_annual.nil?
     @b = Array.new
     @b = Location.where('city like ? AND taxes_annual > ? AND taxpercent > ? AND list_price > ?', loc.city, 0, 0, 0) #? AND taxes_annual_type = true #pull the % taxes for that City
     @avg_taxpct = @b.average("taxpercent").to_f
     loc.update_attributes(:taxpercent => @avg_taxpct)
     loc.update_attributes(:taxes_annual => @avg_taxpct * loc.list_price)
     loc.update_attributes(:taxes_annual_type => false)
     #need to fix this #sol, numbers coming back super high
   else
     loc.update_attributes(:taxpercent => loc.taxes_annual / loc.list_price)
     loc.update_attributes(:taxes_annual_type => true)
   end # if taxes
 end #tax

 def check_beds(loc)
   if loc.beds > 10 || loc.beds == 0
     @d = Array.new
     @d = Location.where('zipcode like ? AND sqft > ? AND sqft < ? AND beds > ?', loc.zipcode, loc.sqft * 0.8, loc.sqft * 1.2, 0)
     @avg_beds = @d.average("beds").to_f.round
     loc.update_attributes(:beds => @avg_beds)
     loc.update_attributes(:beds_type => false)
   else
     loc.update_attributes(:beds_type => true)
   end
   return @avg_beds
 end #beds

 def check_baths(loc)
   if loc.baths > 10 || loc.baths == 0
     @e = Array.new
     @e = Location.where('zipcode like ? AND sqft > ? AND sqft < ? AND baths > ?', loc.zipcode, loc.sqft * 0.8, loc.sqft * 1.2, 0)
     @avg_baths = @e.average("baths").to_f.round
     loc.update_attributes(:baths => @avg_baths)
     loc.update_attributes(:baths_type => false)
   else
     loc.update_attributes(:baths_type => true)
   end
   return @avg_baths
 end #baths

 def calc_cap(loc)
   if loc.caprate.nil? || loc.caprate == 0
     @a_rent = loc.rent_price*12
     @taxes = loc.taxes_annual
#          @a_mnt = loc.maintenance*12
     @buffer = 0.9
     @numerator = (@a_rent - @taxes)*@buffer #add back in @a_mnt once we figure that out
     @newcap = (@numerator/loc.list_price) * 100 #move cap rate from % to a number
     puts loc[:address]

     loc.update_attributes(:caprate => @newcap)
#     binding.pry
   end #if
 end #cap
end
