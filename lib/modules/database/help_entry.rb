module Powerbot
  module Database
    # A help entry.
    class HelpEntry < Sequel::Model
      # Set up class on creation
      def before_create
        super
        self.timestamp ||= Time.now
      end

      # Log creation
      def after_create
        Discordrb::LOGGER.info "created help entry #{inspect}"
      end

      # Composite message for Discord
      def composite
        "🔰 `#{key}:#{id}` - #{text}"
      end
    end
  end
end
