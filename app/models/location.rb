class Location < ActiveRecord::Base

require 'csv'

  attr_accessible :address, :city, :state, :zipcode, :latitude, :beds, :baths,
    :longitude, :zillow_id, :sqft, :rent_price, :list_price, :taxes_annual, :zillow_page_link,
    :price_per_sqft, :rent_per_sqft, :taxpercent,
    :closing_price, :target_price, :maintenance, :listing_type, :commuter_hub,
    :agent, :parking_units, :sqft_type, :last_sold_date, :rent_price_type,
    :taxes_annual_type, :maintenance_type, :maint_percent, :caprate, :closing_price_type, :last_sold_price,
    :real_price, :real_price_type, :beds_type, :baths_type


  geocoded_by :geocoder_input
  reverse_geocoded_by :latitude, :longitude

  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode

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

  def merge
    a = MergeLocations.new(self)
  end #dedupe

#def set_location_information2 #this is not working yet, trying to DRY the below

  #for self.attributes.each do |x|
  #  begin
  #    self.update_attributes(x.to_sym => a.feilds[x.to_sym])
  #  rescue => e
  #    Rails.logger.error { "Encountered an #{e.message} in Setting info"}
  #  end
  #end

  #end

  def set_location_information
    a = AddressInformation.new(self)
    @skip_counter = 0

      if self[:zillow_id].nil? || self[:zillow_id] == "" || self[:zillow_id] == 0
        self.update_attributes(:zillow_id => a.fields[:zillow_id])
      else
        @skip_counter += 1
      end

      if self[:sqft].nil? || self[:sqft] == "" || self[:sqft] == 0
        self.update_attributes(:sqft => a.fields[:sqft])
      else
        @skip_counter += 1
      end

      if self[:rent_price].nil? || self[:rent_price] == "" || self[:rent_price] == 0
        self.update_attributes(:rent_price => a.fields[:rent_price])
      else
        @skip_counter += 1
      end

      if self[:list_price].nil? || self[:list_price] == "" || self[:list_price] == 0
        self.update_attributes(:list_price => a.fields[:list_price])
      else
        @skip_counter += 1
      end

      if self[:beds].nil? || self[:beds] == "" || self[:beds] == 0
        self.update_attributes(:beds => a.fields[:beds])
      else
        @skip_counter += 1
      end

      if self[:baths].nil? || self[:baths] == "" || self[:baths] == 0
        self.update_attributes(:baths => a.fields[:baths])
      else
        @skip_counter += 1
      end

      if self[:zillow_page_link].nil? || self[:zillow_page_link] == "" || self[:zillow_page_link] == 0
        self.update_attributes(:zillow_page_link => a.fields[:zillow_page_link])
      else
        @skip_counter += 1
      end

      if self[:city].nil? || self[:city] == "" || self[:city] == 0
        self.update_attributes(:city => a.fields[:city])
      else
        @skip_counter += 1
      end

      if self[:state].nil? || self[:state] == "" || self[:state] == 0
        self.update_attributes(:state => a.fields[:state])
      else
        @skip_counter += 1
      end

      if self[:zipcode].nil? || self[:zipcode] == "" || self[:zipcode] == 0
        self.update_attributes(:zipcode => a.fields[:zipcode])
      else
        @skip_counter += 1
      end

      self.update_attributes(:address => a.fields[:address])

      puts "#{@skip_counter} attributes were not updated on #{self.address}"


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

      self.update_attributes(:taxpercent => self.taxes_annual / self.list_price)
    rescue TypeError
      Rails.logger.error { "Encountered a TypeError error in (calculating KPIs). Check values: SQFT: #{self.sqft}; $List: #{self.list_price}" }
      # flash[:alert] = "Encountered a TypeError error in Calculating KPIs. Check values: SQFT: #{self.sqft}; $List: #{self.list_price}"
    rescue => e
      Rails.logger.error { "Encountered an #{e.message} in (calculating KPIs). Check values: SQFT: #{self.sqft}; $List: #{self.list_price}"}
      # flash[:alert] = "Encountered an #{e.message} in Calculating KPIs"
    end
  end
#=====================
#=====================

  def self.import(file)
    #@file = "perth_amboy_0816.csv"
    CSV.foreach(file.path, headers: true) do |row|
      Location.create! row.to_hash
      binding.pry
    end #do
    #seems not to get address for some reason

  end #import

end
