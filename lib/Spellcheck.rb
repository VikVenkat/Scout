class Spellcheck
  require 'uri' #This library allows us to do URL string encoding like below

  def initialize(locations, increment)

    @starting_set = Array.new
    @increment = increment
  end #initialize

  def complete_records
    @step1 = location_array.select{ |a| a.list_price.exists?}
    if @step1.length < 10
      @increment *= 0.5

    else
    end
  end
end
