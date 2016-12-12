class TargetInformation #This is the part referenced in the model
  EARTH_rad = 3958.761 #radius of earth in miles
  PI = 3.14159265359

  def initialize(target)
    @target = target
    @lat = @target.latitude
    @lon = @target.longitude
    @radius = @target.radius #will be a distance in miles

  end

  def fields
    return {:north => get_north, :south => get_south, :east => get_east, :west => get_west}
  end

  def get_north
    @target.north = @lat + (@radius / EARTH_rad)*(180/PI)
  end

  def get_south
    @target.south = @lat - (@radius / EARTH_rad)*(180/PI)
  end

  def get_east
    # this is a min longitude
    @target.east = @lon + (@radius / EARTH_rad)*(180/PI) / Math.cos(@lat * (PI / 180))
  end

  def get_west
    @target.west = @lon - (@radius / EARTH_rad)*(180/PI) / Math.cos(@lat * (PI / 180))
  end

end
