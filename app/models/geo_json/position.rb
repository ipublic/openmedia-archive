class GeoJson::Position < Array

  def initialize(*args)
    tuple = args.flatten
    
    # Note: GeoJson supports > 2 or 3 coordinates for geograhic position and ignores > 3 values
    raise ArgumentError, 
      "Requires either two or three ordered numeric arguments: x, y, z" unless tuple.flatten.length.between?(2,3)
    raise ArgumentError,
      "Requires either two or three ordered numeric arguments: x, y, z" unless tuple.all? { |e| Numeric === e }
    super tuple
  end

end
