module OData
  class Query
    # Represents the results of executing a OData::Query.
    # @api private
    class Result
      include Enumerable

      # Initialize a result with the query and the result.
      # @param query [OData::Query]
      # @param result [Typhoeus::Result]
      def initialize(query, result)
        @query      = query
        @result     = result
      end

      # Provided for Enumerable functionality
      # @param block [block] a block to evaluate
      # @return [OData::Entity] each entity in turn for the query result
      def each(&block)
        service.find_entities(result).each do |entity_xml|
          entity = OData::Entity.from_xml(entity_xml, entity_options)
          block_given? ? block.call(entity) : yield(entity)
        end
      end

      private

      attr_reader :query, :result

      def service
        query.entity_set.service
      end

      def entity_options
        query.entity_set.entity_options
      end
    end
  end
end