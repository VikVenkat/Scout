class LocationList #This is the part referenced in the model
  require 'uri' #This library allows us to do URL string encoding like below



  def initialize(target)
    @target = target
    @lat = @target.latitude
    @lon = @target.longitude
    @radius = @target.radius #will be a distance in miles
    @n = @target.north
    @s = @target.south
    @e = @target.east
    @w = @target.west
    @starting_set = Array.new
  end #initialize

  def location_array

    increment = 0.005
    lat_range = @s..@n
    long_range = @w..@e

    lat_range.step(increment).each do |la|
      long_range.step(increment).each do |lo|
        @starting_set << [la, lo]
      end
    end
#    binding.pry #this creates a breakpoint in the console, can use local variables, debug, etc
    return @starting_set
  end #location_array

  def create_locations

    location_array.each do |(x,y)|

      Location.create(:latitude => x, :longitude => y)

    end
  end

end
