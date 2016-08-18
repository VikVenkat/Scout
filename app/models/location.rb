class Location < ActiveRecord::Base

require 'csv'

  attr_accessible :address, :city, :state, :zipcode, :latitude, :beds, :baths,
    :longitude, :zillow_id, :sqft, :rent_price, :list_price, :taxes_annual, :zillow_page_link,
    :price_per_sqft, :rent_per_sqft, :taxpercent,
    :closing_price, :target_price, :maintenance, :listing_type, :commuter_hub,
    :agent, :parking_units, :sqft_type, :last_sold_date, :rent_price_type,
    :taxes_annual_type, :maintenance_type, :maint_percent, :caprate



  #geocoded_by :address
  geocoded_by :geocoder_input
  after_validation :geocode, :if => :address_changed?
  after_create :set_location_information#, :if => :address_changed?
  after_create :set_tax_information#, :if => :address_changed?
  after_create :calculate_KPIs

  def self.small
    Location.find(1)
  end

  #==========

  def geocoder_input
    "#{self.address}"+","+"#{self.city}"+","+"#{self.state}"
  end

  def set_location_information
    a = AddressInformation.new(self)
    # The above class creates a hash with name/value pairs like the below
    if self[:zillow_id].nil?
      self.update_attributes(:zillow_id => a.fields[:zillow_id])
    else
      puts "zillow_id already there"
    end
    if self[:sqft].nil?
      self.update_attributes(:sqft => a.fields[:sqft])
    else
      puts "sqft already there"
    end
    if self[:rent_price].nil?
      self.update_attributes(:rent_price => a.fields[:rent_price])
    else
      puts "rent already there"
    end
    if self[:list_price].nil?
      self.update_attributes(:list_price => a.fields[:list_price])
    else
      puts "prie already there"
    end
    if self[:beds].nil?
      self.update_attributes(:beds => a.fields[:beds])
    else
      puts "beds already there"
    end
    if self[:baths].nil?
      self.update_attributes(:baths => a.fields[:baths])
    else
      puts "baths already there"
    end
    if self[:zillow_page_link].nil?
      self.update_attributes(:zillow_page_link => a.fields[:link])
    else
      puts "link already there"
    end
  end
  def set_tax_information
    a = TaxInformation.new(self)
    if self[:taxes_annual].nil?
      self.update_attributes(:taxes_annual => a.fields[:taxes_annual] )
    end
  end

  def calculate_KPIs
    begin
      self.update_attributes(:price_per_sqft => self.list_price / self.sqft,:rent_per_sqft => self.rent_price / self.sqft)
      #puts self.taxes_annual
      #puts self.list_price
      self.update_attributes(:taxpercent => self.taxes_annual / self.list_price)
    rescue TypeError
      Rails.logger.error { "Encountered a TypeError error in Calculating KPIs. Check values: SQFT: #{self.sqft}; $List: #{self.list_price}" }
      # flash[:alert] = "Encountered a TypeError error in Calculating KPIs. Check values: SQFT: #{self.sqft}; $List: #{self.list_price}"
    rescue => e
      Rails.logger.error { "Encountered an #{e.message} in Calculating KPIs"}
      # flash[:alert] = "Encountered an #{e.message} in Calculating KPIs"
    end
  end
#=====================
#=====================

def self.import(file)
  #@file = "perth_amboy_0816.csv"
  CSV.foreach(file.path, headers: true) do |row|
    Location.create! row.to_hash
  end
  #things that are not working
  #closing proce
  #target price
  #maintenance

end

  def calculate_target_price
    @target_price = 0
    @caprate = 0.1
    if self.rent_price == 0 || self.taxes_annual = 0 || self.maintenance == 0
      #flash[:notice] = "Can't get target price; Check values: Rent:#{self.rent_price}, Taxes:#{self.taxes_annual}, Maint:#{self.maintenance}  "
      puts "Can't get target price; Check values: Rent:#{self.rent_price}, Taxes:#{self.taxes_annual}, Maint:#{self.maintenance}"
    else
      @target_price = ((self.rent_price*12)-self.taxes_annual-(self.maintenance*12))/@caprate
    end
    return @target_price
  end

end
