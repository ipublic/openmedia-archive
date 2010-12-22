module ETL #:nodoc:
  module Control #:nodoc:
    # Destination which writes directly to a database. This is useful when you are dealing with
    # a small amount of data. For larger amounts of data you should probably use the bulk
    # loader if it is supported with your target database as it will use a much faster load
    # method.
    class DatasetDestination < Destination

      attr_reader :dataset_identifier
      
      # Specify the order from the source
      attr_reader :order
      
      # Initialize the dataset destination
      # 
      # * <tt>control</tt>: The ETL::Control::Control instance
      # * <tt>configuration</tt>: The configuration Hash
      # * <tt>mapping</tt>: The mapping
      #
      # Configuration options:
      # * <tt>:dataset_identifier</tt>: The dataset design document id (REQUIRED)
      # * <tt>:unique</tt>: Set to true to only insert unique records (defaults to false)
      # * <tt>:append_rows</tt>: Array of rows to append
      #
      # Mapping options:
      # * <tt>:order</tt>: The order of fields to write (REQUIRED)
      def initialize(control, configuration, mapping={})
        super
        @dataset_identifier = configuration[:dataset]
        @unique = configuration[:unique] ? configuration[:unique] + [scd_effective_date_field] : configuration[:unique]
        @unique.uniq! unless @unique.nil?
        @order = mapping[:order] ? mapping[:order] + scd_required_fields : order_from_source
        @order.uniq! unless @order.nil?
        raise ControlError, "Order required in mapping" unless @order
        raise ControlError, "Dataset required" unless @dataset_identifier
        @dataset = OpenMedia::Dataset.get(@dataset_identifier)
        raise ControlError, "Dataset #{@dataset_identifier} not found in staging database" unless @dataset
      end
      
      # Flush the currently buffered data
      def flush
        docs = buffer.flatten.collect do |row|
          # check to see if this row's compound key constraint already exists
          # note that the compound key constraint may not utilize virtual fields
          next unless row_allowed?(row)

          # add any virtual fields
          add_virtuals!(row)
          doc = { 'couchrest-type' => @dataset.model_name,
                  'import_id' => ETL::Engine.import.id,
                  'created_at' => Time.new,
                  'updated_at' => Time.new }.merge(row)
          doc
        end
        @dataset.model.database.bulk_save(docs)
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
