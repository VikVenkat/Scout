class TaxInformation
  require 'uri' #this library allows us to do URL encoding
  def initialize(location)
    @location = location
  #  @base_url = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=#{ZWSID}&address=#{@location.address}&citystatezip=#{@location.zipcode}&rentzestimate=true"
    @tax_url = URI.encode("http://www.zillow.com/webservice/GetMonthlyPayments.htm?zws-id=#{ZWSID}&price=#{@location.list_price.round(0)}&zip=#{@location.zipcode}")
  end

  def fields
    return {:taxes_annual => get_taxes_annual}
  end

  def get_zillow_api_tax
    a = Nokogiri::XML(Typhoeus.get(@tax_url).body)
    # puts @tax_url
    # puts a.xpath('//message').text
    return a

  end

  def zillow_api_tax
    @zillow_tax_info ||= get_zillow_api_tax
    #this turns the above into a local variable, indicated in ruby with an @ sign
  end

  def get_taxes_annual
    # note that zipcode is required for this to work
  #  if @location.taxes_annual.nil?
      a = @location.taxes_annual = zillow_api_tax.xpath('//monthlyPropertyTaxes').text.to_f
      return 12*a
      # If that also null
      #  within Area
      #  calculate average taxpercent * Listing_price
      # end
  #  else
  #    @location.taxes_annual
  #  end
  end

end
