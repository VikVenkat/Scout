class LocationList #This is the part referenced in the model
  require 'uri' #This library allows us to do URL string encoding like below

  starting_set = Array.new

  def initialize(target)
    @target = target
    @lat = @target.latitude
    @lon = @target.longitude
    @radius = @target.radius #will be a distance in miles
    @n = @target.north
    @s = @target.south
    @e = @target.east
    @w = @target.west
  end

  def location_array

  increment = .005
  y = @s
  x = @e
  ycount = 0
  xcount = 0

    while y < @n do
      while x < @w do

        starting_set[xcount][ycount] = [x][y]

        x+=increment
        xcount++
      end
      y+=increment
      ycount++
    end

    return starting_set
  end

  def create_locations
    location_array.each do |(x,y)|

      Location.create(:latitude => x, :longitude => y)

    end
  end

end
