module OpenMedia
  module Connection
  class FileAdapter < Adapter
  
    attr_reader :path, :time_modified, :size

    def initialize(path)
      @path = path
      
      @size = File.size(@path)
      @time_modified = File.mtime(@path)
    end

    def to_hash
      Hash[:adapter_type => self.class.to_s,
            :path => @path, 
            :time_modified => @time_modified, 
            :size => @size]
    end
  end
end
end
