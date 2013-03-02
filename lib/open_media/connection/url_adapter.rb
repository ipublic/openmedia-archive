require 'rest_client'
require 'json'
RestClient.log = '/tmp/om_rest_client.log'

module OpenMedia
  module Connection
    class UrlAdapter < Adapter
  
      ACTIONS = %w(get post)
      attr_accessor :name, :url, :headers, :action, :user, :password, :parameters

      # def initialize()
      # end

      def action=(http_verb)
        raise "#{http_verb} is unsupported. Use HTTP verb 'get' or 'post'" unless ACTIONS.include?(http_verb.downcase)
        @action = http_verb.downcase
      end
      
      def parameters=(params)
        raise "parmeters must be a hash" unless params.class == Hash
        @parameters = params
      end
      
      def execute
        response = RestClient.get @url, :params => @parameters
        JSON.parse response.body if response.headers[:content_type].include? "application/json"
      end
      
      def to_s
        "#{@action} #{@url}?#{@parameters}"
      end

      def to_hash
        Hash[:adapter_type => self.class.to_s]
      end
    end
  end
end
