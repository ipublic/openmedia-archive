require 'digest/sha2'
require 'open_media/schema/rdfs/class'

module ETL #:nodoc:
  module Control #:nodoc:
    # Destination which writes directly to a database. This is useful when you are dealing with
    # a small amount of data. For larger amounts of data you should probably use the bulk
    # loader if it is supported with your target database as it will use a much faster load
    # method.
    class RdfsClassDestination < Destination

      attr_reader :type_id
      
      # Specify the order from the source
      attr_reader :order
      
      # Initialize the dataset destination
      # 
      # * <tt>control</tt>: The ETL::Control::Control instance
      # * <tt>configuration</tt>: The configuration Hash
      # * <tt>mapping</tt>: The mapping
      #
      # Configuration options:
      # * <tt>:datasource</tt>: The datasource data is coming from
      # * <tt>:unique</tt>: Set to true to only insert unique records (defaults to false)
      # * <tt>:append_rows</tt>: Array of rows to append
      #
      # Mapping options:
      # * <tt>:order</tt>: The order of fields to write (REQUIRED)
      def initialize(control, configuration, mapping={})
        super
        @rdfs_class_uri = configuration[:rdfs_class]
        @unique = configuration[:unique] ? configuration[:unique] + [scd_effective_date_field] : configuration[:unique]
        @unique.uniq! unless @unique.nil?
        @order = mapping[:order] ? mapping[:order] + scd_required_fields : order_from_source
        @order.uniq! unless @order.nil?
        raise ControlError, "Order required in mapping" unless @order
        raise ControlError, "RDFS Class required" unless @rdfs_class_uri
        @rdfs_class = OpenMedia::Schema::RDFS::Class.for(@rdfs_class_uri)
        raise ControlError, "Class #{@rdfs_class_uri} not found in schema" unless @rdfs_class.exists?
      end
      
      # Flush the currently buffered data
      def flush
        ts = Time.now.to_i
        rdf_statements = buffer.flatten.collect do |row|
          # check to see if this row's compound key constraint already exists
          # note that the compound key constraint may not utilize virtual fields
          next unless row_allowed?(row)

          # add any virtual fields
          add_virtuals!(row)
          
          # Use the rdfs class's dynamic spira resource to create the rdf statements, but
          # bulk save them to repository manually
          uri = @rdfs_class.uri/"##{Digest::SHA2.hexdigest(row.to_s)}-#{ts}"
          r = @rdfs_class.for(uri, row)
          r.before_save
          r.before_create          
          r.statements.to_a          
        end
        repo = @rdfs_class.spira_resource.repository
        # fancy way to flatten array, since flattening array of RDF::Statement caused statements to break
        rdf_statements = rdf_statements.inject([]) {|ary, stmts| ary.concat(stmts)}
        repo.insert_statements(rdf_statements)
        buffer.clear        
      end
      
      # Close the connection
      def close
        buffer << append_rows if append_rows
        flush
      end
            
    end
  end
end
