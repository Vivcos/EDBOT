require 'matrix'

module Powerbot
  # Traikoa API
  module Traikoa
    # Position in 3D space
    module Position
      attr_reader :x
      attr_reader :y
      attr_reader :z

      def distance(other)
        (vector - other.vector).r
      end

      def vector
        Vector[x, y, z]
      end
    end

    # A System in space
    class System
      include Position

      # @return [Integer] system ID
      attr_reader :id

      # @return [String] name
      attr_reader :name

      # @return [Position] position
      attr_reader :position

      # @return [Integer] population
      attr_reader :population

      # @return [String] allegiance
      attr_reader :allegiance

      # @return [String] security level
      attr_reader :security

      # @return [true, false] whether this system needs a permit
      attr_reader :needs_permit
      alias permit? needs_permit

      # @return [Hash] station metadata
      attr_reader :stations

      # @return [Integer] cc_value
      attr_reader :cc_value

      # @return [true, false] whether this system is contested
      attr_reader :contested
      alias contested? contested

      # @return [Hash] exploitation metadata
      attr_reader :exploitations

      # @return [Integer] id of this system as a control system, if applicable
      attr_reader :control_system_id

      def initialize(data)
        @id = data[:id]
        @name = data[:name]
        @x = data[:position][:x]
        @y = data[:position][:y]
        @z = data[:position][:z]
        @population = data[:population]
        @allegiance = data[:allegiance]
        @security = data[:security]
        @needs_permit = data[:needs_permit]
        @stations = data[:stations]
        @cc_value = data[:cc_value]
        @contested = data[:contested]
        @exploitations = data[:exploitations]
        @control_system_id = data[:control_system_id]
      end

      # Load a system from the API
      # @param id [Integer] system ID
      # @return [System]
      def self.load(id)
        new API::System.get id
      end

      # Loads multiple systems from a search by name
      # @param name [String, Array<Integer>] name of system, or array of IDs
      # @return [Array<System>] possible matches
      def self.search(data)
        results = API::System.search data
        results.map { |s| new s }
      end

      # @param radius [Integer, Float] radius to query
      # @return [Array<System>] systems within specified radius
      def bubble(radius = 15)
        results = API::System.bubble id, radius
        results[:systems].map { |s| System.new s }
      end

      # @return [true, false] whether this system is exploited
      def exploited?
        @exploitations.any?
      end
    end

    # A Control System controlled by a Power
    class ControlSystem
      # @return [Integer] control system ID
      attr_reader :id

      # @return [Integer] power id
      attr_reader :power_id

      # @return [System] host system for this control system
      attr_reader :system

      # @return [Hash] volatile data related to this control system
      attr_reader :control_data
      alias data control_data

      # @return [Hash] exploitation metadata
      attr_reader :exploitations

      def initialize(data)
        @id = data[:id]
        @power_id = data[:power_id]
        @system = System.load data[:system_id]
        @control_data = data[:control_data]
        @exploitations = data[:exploitations]
      end

      # @return [String] name of the control system
      def name
        @system.name
      end

      # @param [ControlSystem, System] what to measure distance to
      # @return [Float] distance to other system
      def distance(target)
        target = target.system if target.is_a? ControlSystem
        @system.distance target
      end

      # Load a control system from the API
      # @param [Integer] ID of the control system
      # @return [ControlSystem]
      def self.load(id)
        new API::ControlSystem.resolve_id id
      end

      # Load multiple control systems from an array of IDs
      # @param [Array<Integer>] IDs of control systems
      # @return [Array<ControlSystem>]
      def self.search(ids)
        results = API::ControlSystem.search ids
        results.map { |cs| ControlSystem.new cs }
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

        def search(data)
          if data.is_a? String
            data = URI.encode data
            return get "search?name=#{data}"
          end

          if data.is_a? Array
            return get 'search', ids: data
          end
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

        def search(ids)
          get 'search', ids: ids
        end
      end

      module Power
        NAMESPACE = 'powers'

        module_function

        def get(path = '', params = {})
          API.get "#{NAMESPACE}/#{path}", params
        end

        def list
          get
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
