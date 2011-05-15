module ETL #:nodoc:
  module Control #:nodoc:
    # A File source.
    class DatasourceSource < Source

      attr_accessor :datasource_id
      
      # Initialize the source
      #
      # Configuration options:
      # * <tt>:file</tt>: The source file
      # * <tt>:parser</tt>: One of the following: a parser name as a String or
      #   symbol, a class which extends from Parser, a Hash with :name and 
      #   optionally an :options key. Whether or not the parser uses the 
      #   options is dependent on which parser is used. See the documentation 
      #   for each parser for information on what options it accepts.
      # * <tt>:skip_lines</tt>: The number of lines to skip (defaults to 0)
      # * <tt>:store_locally</tt>: Set to false to not store a copy of the 
      #   source data locally for archival
      def initialize(control, configuration, definition)
        super
        @datasource_id = configuration[:datasource]
        @datasource = OpenMedia::Datasource.find(@datasource_id)
      end
      
      # Get a String identifier for the source
      def to_s
        @datasource_id
      end
      
      # Get the local storage directory
      def local_directory
        File.join(local_base, File.basename(@datasource_id, 'csv'))
      end
      
      # Returns each row from the source
      def each
        # count = 0
        # copy_sources if store_locally
        # @parser.each do |row|
        #   if ETL::Engine.offset && count < ETL::Engine.offset
        #     count += 1
        #   else
        #     row = ETL::Row[row]
        #     row.source = self
        #     yield row
        #   end
        # end
        
        @datasource.unpublished_raw_records.each do |rr|
          yield rr
        end

      end
    end
  end
end
