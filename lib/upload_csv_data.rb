class UploadCSVData
  require 'csv'
  def initialize
    @data = CSV.read("perth_amboy_0816.csv")
    @parsed = Hash.new #{ |hash, key| hash[key] =  }
  end

  def parse_file #input file, put out rows
    @data.each do |row|

      row.each do |col|
        @parsed{row => col} = {row[0][col].gsub(/\s+/, '').to_sym => col}
      end
    end
    return @parsed
  end

  def map_file #input parsed file, put out :locations
  end

end
