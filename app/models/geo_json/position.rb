class GeoJson::Position < Array
  
  attr_reader :coordinates

  def initialize(*args)
    tuple = args.flatten
    
    # Note: GeoJson supports > 2 or 3 coordinates for geograhic position and ignores > 3 values
    raise ArgumentError, 
      "Requires either two or three ordered numeric arguments: x, y, z" unless tuple.length.between?(2,3)
    raise ArgumentError,
      "Requires either two or three ordered numeric arguments: x, y, z" unless tuple.all? { |e| Numeric === e }

    super
    @coordinates = tuple
  end
end
