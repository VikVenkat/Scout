class LocationList #This is the part referenced in the model
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

#  def fields
#    return coord_array
#  end

  def create_locations

    @location_array = Array.new
    @search_result

    coord_array.each do |(x,y)| # update this to include the above
      @geo = Hash.new
      @search_result = Geocoder.search([x,y]).first

          @geo.store(:address , @search_result.street_number + " " + @search_result.route )
          @geo.store(:city , @search_result.city)
          @geo.store(:state , @search_result.state)
      @location_array.push(@geo)
#      puts @geo
#      puts @location_array
    end #do
#    puts "Outside Loop"
#    puts @geo
#    @location_array.uniq
#    puts @location_array
#    binding.pry
    puts @location_array
    return @location_array #works!

  end #create_locations

  #old version
#  def create_locations
#    coord_array.each do |(x,y)| # update this to include the above
#      Location.create(:latitude => x, :longitude => y)
#    end #do
#  end #create_locations

end
