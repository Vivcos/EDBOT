module Powerbot
  module Database
    # A Discord message
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

      # Fetch message from cache
      def message
        BOT.channel(channel_id).message(message_id)
      end
    end
  end
end
