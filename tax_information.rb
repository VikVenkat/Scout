class TaxInformation
  def initialize(location)
    @location = location
  #  @base_url = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=#{ZWSID}&address=#{@location.address}&citystatezip=#{@location.zipcode}&rentzestimate=true"
    @tax_url = "http://www.zillow.com/webservice/GetMonthlyPayments.htm?zws-id=#{ZWSID}&price=#{@location.list_price}&zip=#{@location.zipcode}"
  end

  def fields
    return {:taxes_annual => get_taxes_annual}
  end

  def get_zillow_api_tax
    Nokogiri::XML(Typhoeus.get(@tax_url).body)
    # this makes the method name an object we can refer to
  end

  def zillow_api_tax
    @zillow_tax_info ||= get_zillow_api_tax
    #this turns the above into a local variable, indicated in ruby with an @ sign
  end

  def get_taxes_annual
    # note that zipcode is required for this to work
    if @location.taxes_annual IS NULL
      @location.taxes_annual = @zillow_tax_info.xpath('//monthlyPropertyTaxes').text.to_f
      # If that also null
      #  within Area
      #  calculate average taxpercent * Listing_price
      # end
    else
      @location.taxes_annual
    end
  end

end
