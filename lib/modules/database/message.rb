module Powerbot
  module Database
    class Message < Sequel::Model
      # Set timestamp before creation
      def before_create
        super
        self.timestamp = Time.now
      end

      # Log creation
      def after_create
        Discordrb::LOGGER.info "created message: #{inspect}"
      end
    end
  end
end
