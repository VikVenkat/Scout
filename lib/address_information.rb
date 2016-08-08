class AddressInformation #This is the part referenced in the model
  require 'uri' #This library allows us to do URL string encoding like below


  def initialize(location)
    @location = location
    @city_state_zip = "#{@location.city}"+","+"#{@location.state}"+","+"#{@location.zipcode}"
    @base_url = URI.encode("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=#{ZWSID}&address=#{@location.address}&citystatezip=#{@city_state_zip}&rentzestimate=true")
  #  @tax_url = "http://www.zillow.com/webservice/GetMonthlyPayments.htm?zws-id=#{ZWSID}&price=#{@location.list_price}&zip=#{@location.zipcode}"
  #  @test_url = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz19muc0cecy3_4eq90&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA&rentzestimate=true"
  end

  def get_address_information
  end

  def get_zillow_api
    a = Nokogiri::XML(Typhoeus.get(@base_url).body)
    #puts @base_url
    puts a.xpath('//message/text').text
    return a
    # this makes the method name an object we can refer to
  end

  def zillow_api_info
    @zillow_api_info ||= get_zillow_api
    #this turns the above into a local variable, indicated in ruby with an @ sign
  end

  def fields
    return {:zillow_id => get_zillow_id, :sqft => get_sqft, :rent_price => get_rent_price, :list_price => get_list_price, :beds => get_beds, :baths => get_baths, :link => get_zillow_link}

  end
  def get_beds
    @location.beds = zillow_api_info.xpath('//bedrooms').text.to_f
  end

  def get_baths
    @location.baths = zillow_api_info.xpath('//bathrooms').text.to_f
  end

  def get_zillow_link
    @location.zillow_page_link = zillow_api_info.xpath('//homedetails').text
  end

  def get_zillow_id
    #if @location.zillow_id.nil?
      @location.zillow_id = zillow_api_info.xpath('//zpid').text
    #else
    #  @location.zillow_id
    #end
  end

  def get_sqft
    #if @location.sqft.nil?

      @location.sqft = zillow_api_info.xpath('//finishedSqFt').text

      # If that also null
      #  within Area
      #  calculate average sqft for number of Bedrooms
      # end
    #else
    #  @location.sqft
    #end
  end

  def get_rent_price
    #if @location.rent_price.nil?
      @location.rent_price = zillow_api_info.xpath('//rentzestimate/amount').text
      # If that also null
      #  within Area
      #  calculate average rent/sqft and * sqft
      # end
    #else
    #  @location.rent_price
    #end
  end

  def get_list_price
    #if @location.list_price.nil?
      @location.list_price = zillow_api_info.xpath('//zestimate/amount').text.to_f
    #else
    #  @location.list_price
    #end
  end



end
