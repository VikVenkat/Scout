class UploadCSVData
  require 'csv'
  def initialize
#    @data = CSV.read("perth_amboy_0816.csv")
    #@parsed = Array.new
  end

def cleanup

  @data.each do |row|
    row.each do |col|
      if @data[col][0].nil?
        @data[col].delete_at(row)
      else
        @parsed[row][col] = @data[row][col]
      #[col].gsub(/\s+/, '')
      end #if
    end #col do
  end #row do
  return @parsed
end #method

# want to loop through the records, and write each one to the DB
  def lookup(row,col) #input file, put out rows
    @data.each do |row|

      row.each do |col|
        @parsed[row][col] = row[0][col].to_sym => col
      end
    end
    return @parsed
  end

  def map_file #input parsed file, put out :locations
  end

end
