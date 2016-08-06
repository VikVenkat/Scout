class Location < ActiveRecord::Base

  attr_accessible :address, :city, :state, :zipcode, :latitude,
    :longitude, :zillow_id, :sqft, :rent_price, :list_price, :taxes_annual,
    :price_per_sqft, :rent_per_sqft, :taxpercent

  #geocoded_by :address
  geocoded_by :geocoder_input
  after_validation :geocode, :if => :address_changed?
  after_create :set_location_information#, :if => :address_changed?
  after_create :set_tax_information#, :if => :address_changed?
  after_create :calculate_KPIs

  def self.small
    Location.find(4)
  end

  #==========

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

  def calculate_KPIs
    self.update_attributes(:price_per_sqft => self.list_price / self.sqft,:rent_per_sqft => self.rent_price / self.sqft)
    puts self.taxes_annual
    puts self.list_price

    self.update_attributes(:taxpercent => self.taxes_annual / self.list_price)
  end

end
