class MergeLocations

  def initialize
    @counter = 0
  end #initialize

  def merge
    Location.all.each do |loc| #1
      # Run through each location
#      puts "#{Location.where('zillow_id == ? AND id > ?', loc.zillow_id, loc.id).count} comparisons to do for #{loc[:address]} "
      Location.where('zillow_id == ? AND id > ?', loc.zillow_id, loc.id).each do |comp| #2
        # Compare the location in question to dupes by zillow
        #do the merging here
        #what is the DRY version of the below? like loc.attributes.each? #sol
        fix_beds(loc, comp)
        fix_baths(loc, comp)
        fix_sqft(loc, comp)
        fix_list_price(loc, comp)
        fix_rent_price(loc, comp)
        fix_taxes_annual(loc,comp)
#        loc.save! #sol suggested making the update attributes into assignments then saving

        puts "Deleted Location ID #{comp.id}"
        comp.destroy
        @counter += 1

      end #do 2
    end #do 1
#    binding.pry
    return @counter
  end #merge #works!

  def fix_beds(loc, comp)
    if loc.beds != comp.beds
      loc.beds = [loc.beds, comp.beds].max
      loc.update_attributes!(:beds => [loc.beds, comp.beds].max)
    end
  end #beds

  def fix_baths(loc, comp)
    if loc.baths != comp.baths
      loc.update_attributes(:baths => [loc.baths, comp.baths].max)
    end #if baths
  end #baths

  def fix_sqft(loc, comp)
    if loc.sqft != comp.sqft
      if loc.sqft_type  && comp.sqft_type
        loc.update_attributes(:sqft => [loc.sqft, comp.sqft].max)
        loc.update_attributes(:price_per_sqft => loc.list_price / loc.sqft)
        loc.update_attributes(:rent_per_sqft => loc.rent_price / loc.sqft)
      elsif loc.sqft_type
      elsif comp.sqft_type
        loc.update_attributes(:sqft => comp.sqft)
        loc.update_attributes(:sqft_type => comp.sqft_type)
      else
        loc.update_attributes(:sqft => [loc.sqft, comp.sqft].max)
        loc.update_attributes(:price_per_sqft => loc.list_price / loc.sqft)
        loc.update_attributes(:rent_per_sqft => loc.rent_price / loc.sqft)
      end
    end #if sqft
  end #sqft

  def fix_list_price(loc, comp)
    if loc.list_price != comp.list_price
      loc.update_attributes(:list_price => [loc.list_price, comp.list_price].max)
      loc.update_attributes(:price_per_sqft => loc.list_price / loc.sqft)
      loc.update_attributes(:taxpercent => loc.taxes_annual / loc.list_price)
    end #if list_price
  end #list_price

  def fix_rent_price(loc, comp)
    if loc.rent_price != comp.rent_price
        if loc.rent_price > 0 && comp.rent_price > 0
          loc.update_attributes(:rent_price => [loc.rent_price, comp.rent_price].min)
        else
          loc.update_attributes(:rent_price => [loc.rent_price, comp.rent_price].max)
        end

        if loc.sqft > 0
          loc.update_attributes(:rent_per_sqft => loc.rent_price / loc.sqft)
        end
    end #if rent_price
  end #rent

  def fix_taxes_annual(loc, comp)
    if loc.taxes_annual != comp.taxes_annual
      loc.update_attributes(:taxes_annual => [loc.taxes_annual, comp.taxes_annual].max)
      loc.update_attributes(:taxpercent => loc.taxes_annual / loc.list_price)
    end #if taxes_annual
  end #taxes
end #class
