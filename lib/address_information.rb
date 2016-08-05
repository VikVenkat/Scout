class AddressInformation #This is the part referenced in the model
  def initialize(location)
    @location = location
    @base_url = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=#{ZWSID}&address=#{@location.address}&citystatezip=#{@location.zipcode}&rentzestimate=true"
  #  @tax_url = "http://www.zillow.com/webservice/GetMonthlyPayments.htm?zws-id=#{ZWSID}&price=#{@location.list_price}&zip=#{@location.zipcode}"
    @test_url = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz19muc0cecy3_4eq90&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA&rentzestimate=true"
  end

  def get_address_information
  end

  def get_zillow_api
    Nokogiri::XML(Typhoeus.get(@base_url).body)
    # this makes the method name an object we can refer to
  end

  def zillow_api
    @zillow_api_info ||= get_zillow_api
    #this turns the above into a local variable, indicated in ruby with an @ sign
    # Check with Sol, why did we do OR-Equals here?
  end

  def fields
    return {:zillow_id => get_zillow_id, :sqft => get_sqft, :rent_price => get_rent_price, :list_price => get_list_price}
      #:taxes_annual => get_taxes_annual}
  end
=begin
  def get_zip
    if @location.zipcode IS NULL
      puts "Error: Locations must have zipcodes"
      # How to get zip? Gmaps?
    end
  end
=end

  def get_zillow_id
    if @location.zillow_id IS NULL
      @location.zillow_id = @zillow_api_info.xpath('//zpid').text
    else
      @location.zillow_id
    end
  end

  def get_sqft
    if @location.sqft IS NULL

      @location.sqft = @zillow_api_info.xpath('//finishedSqFt').text

      # If that also null
      #  within Area
      #  calculate average sqft for number of Bedrooms
      # end
    else
      @location.sqft
    end
  end

  def get_rent_price
    if @location.rent_price IS NULL
      @location.rent_price = @zillow_api_info.xpath('//rentzestimate/amount').text
      # If that also null
      #  within Area
      #  calculate average rent/sqft and * sqft
      # end
    else
      @location.rent_price
    end
  end

  def get_list_price
    if @location.list_price IS NULL
      @location.list_price = @zillow_api_info.xpath('//zestimate/amount').text.to_f
    else
      @location.rent_price
    end
  end



end
