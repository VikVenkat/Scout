class MergeTargets

  def initialize(target)
    @counter = 0
    @id = target.id
  end #initialize

  def merge
    Target.all.each do |loc| #1
      # Run through each target
      Target.where('address == ? AND id > ? AND id < ?', loc.address, loc.id, @id).each do |comp| #2
        # Compare the location in question to dupes by address
        #do the merging here
        #what is the DRY version of the below? like loc.attributes.each? #sol
        if loc.radius != comp.radius
#          loc.update_attributes(:radius => [loc.radius, comp.radius].max)
        else #if radius

          puts "Deleted Target ID #{comp.id}"
          comp.destroy
          @counter += 1
        end #if radius
      end #do 2
    end #do 1
#    binding.pry
    return @counter
  end #merge #works!

end #class
