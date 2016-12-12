class Target < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :address, :radius, :north, :south, :east, :west

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  after_create :set_bounds

  def set_bounds
    a = TargetInformation.new(self)

    self.update_attributes(:north => a.fields[:north])
    self.update_attributes(:south => a.fields[:south])
    self.update_attributes(:east => a.fields[:east])
    self.update_attributes(:west => a.fields[:west])
  end
end
