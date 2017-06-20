class AddressInformation #This is the part referenced in the model
  require 'uri' #This library allows us to do URL string encoding like below


  def initialize(location)
    @location = location
    @city_state_zip = "#{@location.city},#{@location.state},#{@location.zipcode}"
    @base_url = URI.encode("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=#{ZWSID}&address=#{@location.address}&citystatezip=#{@city_state_zip}&rentzestimate=true")
    #  @tax_url = "http://www.zillow.com/webservice/GetMonthlyPayments.htm?zws-id=#{ZWSID}&price=#{@location.list_price}&zip=#{@location.zipcode}"
    #  @test_url = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz19muc0cecy3_4eq90&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA&rentzestimate=true"
  end

  def update_location
    @location.beds ||= zillow_api_info.xpath('//bedrooms').text.to_f
    @location.baths ||= zillow_api_info.xpath('//bathrooms').text.to_f
    @location.zillow_page_link ||= zillow_api_info.xpath('//homedetails').text
    @location.zillow_id ||= zillow_api_info.xpath('//zpid').text
    @location.sqft ||= zillow_api_info.xpath('//finishedSqFt').text.to_f
    @location.rent_price ||= zillow_api_info.xpath('//rentzestimate/amount').text.to_f
    @location.list_price ||= zillow_api_info.xpath('//zestimate/amount').text.to_f
    @location.city ||= zillow_api_info.xpath('//address/city').text
    @location.state ||= zillow_api_info.xpath('//address/state').text
    @location.zipcode ||= zillow_api_info.xpath('//address/zipcode').text
    # but sometimes there are multiple addresse. How to get them all? #sol
    # updating these pulls with a ).first.text then breaks because errors are thrown instead of blanks
    # do i have to write begin loops on all of these?
    @location.address ||= zillow_api_info.xpath('//address/street').text
    @location #return
  end

  private

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

  ####################
  # def beds
  #   @location.beds = zillow_api_info.xpath('//bedrooms').text.to_f
  # end
  #
  # def baths
  #   @location.baths = zillow_api_info.xpath('//bathrooms').text.to_f
  # end
  #
  # def zillow_link
  #   @location.zillow_page_link = zillow_api_info.xpath('//homedetails').text
  # end
  #
  # def zillow_id
  #   @location.zillow_id = zillow_api_info.xpath('//zpid').text
  # end
  #
  # def sqft
  #   @location.sqft = zillow_api_info.xpath('//finishedSqFt').text.to_f
  # end
  #
  # def rent_price
  #   @location.rent_price = zillow_api_info.xpath('//rentzestimate/amount').text.to_f
  # end
  #
  # def list_price
  #   @location.list_price = zillow_api_info.xpath('//zestimate/amount').text.to_f
  #   #      binding.pry
  # end
  #
  # def city
  #   @location.city = zillow_api_info.xpath('//address/city').text
  # end
  #
  # def state
  #   @location.state = zillow_api_info.xpath('//address/state').text
  # end
  #
  # def zip
  #   @location.zipcode = zillow_api_info.xpath('//address/zipcode').text
  # end
  #
  # def address
  #   # but sometimes there are multiple addresse. How to get them all? #sol
  #   # updating these pulls with a ).first.text then breaks because errors are thrown instead of blanks
  #   # do i have to write begin loops on all of these?
  #   @location.address = zillow_api_info.xpath('//address/street').text
  # end



end
