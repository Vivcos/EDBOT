require 'matrix'

module Powerbot
  # Traikoa API
  module Traikoa
    # Position in 3D space
    class Position
      attr_reader :x
      attr_reader :y
      attr_reader :z

      def initialize(x, y, z)
        @x = x
        @y = y
        @z = z
      end

      def distance(other)
        (vector - other.vector).r
      end

      def vector
        Vector[x, y, z]
      end
    end

    # A System in space
    class System
      # @return [Integer] system ID
      attr_reader :id

      # @return [String] name
      attr_reader :name

      # @return [Position] postion
      attr_reader :position

      def initialize(data)
        @id = data[:id]
        @name = data[:name]
        @position = Position.new data[:position][:x], data[:position][:y], data[:position][:z]
      end

      # Load a system from the API
      # @param id [Integer] system ID
      def self.load(id)
        new API::System.get id
      end

      # Loads multiple systems from a search by name
      # @param name [String] name of system
      def self.search(name)
        results = API::System.search name
        results.map { |s| new s }
      end

      # @return [Float] distance to other system
      # @param [System] system to measure distance to
      def distance(other)
        position.distance other.position
      end

      # @return [Array<System>] systems within specified radius
      # @param radius [Integer, Float] radius to query 
      def bubble(radius = 15)
        results = API::System.bubble id, radius
        results[:systems].map { |s| System.new s }
      end
    end

    # REST
    module API
      API_URL = CONFIG.api_url
      API_VERSION = 'v1'

      module_function

      # Generic GET request
      def get(path = '', params = {})
        response = RestClient.get "#{API_URL}/#{API_VERSION}/#{path}", params: params
        JSON.parse response, symbolize_names: true
      end

      # Generic POST request
      def post(path = '', payload = {})
        response = RestClient.post "#{API_URL}/#{API_VERSION}/#{path}", payload.to_json, { content_type: :json }
        JSON.parse response
      end

      module System
        NAMESPACE = 'systems'

        module_function

        def get(path = '', params = {})
          API.get "#{NAMESPACE}/#{path}", params
        end

        def resolve_id(id)
          get id
        end

        def search(name)
          get 'search', { name: name }
        end

        def bubble(id, radius)
          get 'bubble', { id: id, radius: radius }
        end
      end

      module ControlSystem
        NAMESPACE = 'control_systems'

        module_function

        def get(path = '', params = {})
          API.get "#{NAMESPACE}/#{path}", params
        end

        def resolve_id(id)
          get id
        end
      end

      module Power
        NAMESPACE = 'powers'

        module_function

        def get(path = '', params = {})
          API.get "#{NAMESPACE}/#{path}", params
        end

        def resolve_id(id)
          get id
        end
      end

      module Cmdr
        NAMESPACE = 'cmdrs'

        module_function

        def get(path = '', params = {})
          API.get "#{NAMESPACE}/#{path}", params
        end

        def resolve_id(id)
          get id
        end
      end
    end
  end
end
