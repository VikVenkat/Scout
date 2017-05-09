class Target < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :address, :radius, :north, :south, :east, :west

  reverse_geocoded_by :latitude, :longitude
  geocoded_by :geocoder_input

  after_validation :reverse_geocode
  after_validation :geocode, :if => :address_changed?

  after_create :set_bounds, :if => :radius_changed?
  after_create :create_locations

  def geocoder_input
    "#{self.address}"#+","+"#{self.city}"+","+"#{self.state}"
  end

  def set_bounds
    a = TargetInformation.new(self)

    self.update_attributes(:north => a.fields[:north])
    self.update_attributes(:south => a.fields[:south])
    self.update_attributes(:east => a.fields[:east])
    self.update_attributes(:west => a.fields[:west])
  end

  def create_locations
    #using the bounds above, loop though them and get addresses
    #create each address as a Location
    @increment = 0.005 #in radians (of the earth!) not miles

    a = TargetLocationList.new(self, @increment)
    b = a.calculated_locations

#    c = Spellcheck.new(b, @increment)
#    d = c.price_check

  end


end
