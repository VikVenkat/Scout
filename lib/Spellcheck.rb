class Spellcheck
  require 'uri' #This library allows us to do URL string encoding like below

  def initialize(locations, increment)
    @location_array = locations
    @increment = increment
  end #initialize

  def price_check
    @price_check_array = Array.new

    @location_array.each do |a|
#      binding.pry
#      b = a.set_location_information
#      @price_check_array.push(b)
    end #do
    binding.pry
# => Sol's Version
#    @step1 = @location_array.select{ |a| a.list_price.exists?}
#    if @step1.length < 10
#      @increment *= 0.5
#    end
  end #price_check
end
