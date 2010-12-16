module OpenMedia::ETL #:nodoc:
  module Processor #:nodoc:
    # A processor which will truncate a table. Use as a pre-processor for cleaning out a table
    # prior to loading
    class TruncateProcessor < OpenMedia::ETL::Processor::Processor
      # Defines the table to truncate
      attr_reader :table
      
      # Defines the database connection to use
      attr_reader :target
      
      # Initialize the processor
      #
      # Options:
      # * <tt>:target</tt>: The target connection
      # * <tt>:table</tt>: The table name
      def initialize(control, configuration)
        super
        #@file = File.join(File.dirname(control.file), configuration[:file])
        @target = configuration[:target] || {}
        @table = configuration[:table]
      end
      
      def process
        conn = OpenMedia::ETL::Engine.connection(target)
        conn.truncate(table_name)
      end
      
      private
      def table_name
        OpenMedia::ETL::Engine.table(table, OpenMedia::ETL::Engine.connection(target))
      end
    end
  end
end
