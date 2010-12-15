module OpenMedia::ETL
  module Transform
    class BlockTransform < OpenMedia::ETL::Transform::Transform
      def initialize(control, name, configuration)
        super
        @block = configuration[:block]
      end
      def transform(name, value, row)
        @block.call(name, value, row)
      end
    end
  end
end
