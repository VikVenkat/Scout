class Location < ActiveRecord::Base
  attr_accessible :address, :city, :state, :zipcode, :latitude, :longitude

  #geocoded_by :address
  geocoded_by :geocoder_input
  after_validation :geocode, :if => :address_changed?

  def self.small
    Location.find(4)
  end

  #==========
  # Review the below with Sol
  # ZWSID = X1-ZWz19muc0cecy3_4eq90
  def geocoder_input
    "#{self.address}"+","+"#{self.city}"+","+"#{self.state}"
  end
  # validates :address, presence: true
  def set_location_information
    a = AddressInformation.new(self)
    # The above class creates a hash with name/value pairs like the below
    self.update_attributes(:zillow_id => a.fields[:zillow_id], :sqft => a.fields[:sqft], :rent_price => a.fields[:rent_price], :list_price => a.fields[:list_price] )
  end
  def set_tax_information
    a = TaxInformation.new(self)
    self.update_attributes(:taxes_annual => a.fields[:taxes_annual] )
  end
=begin
  def self.calculate_KPI
    :price_per_sqft = :list_price / :sqft
    :rent_per_sqft = :rent_price / :sqft
    :taxpercent = :taxes_annual / :list_price
  end
=end
end
