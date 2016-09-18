module Powerbot
  module Database
    # Moderation log
    class ModLog < Sequel::Model
      many_to_one :message

      # Set timestamp before creation
      def before_create
        super
        self.timestamp = Time.now
      end

      # Log creation
      def after_create
        Discordrb::LOGGER.info "created message: #{inspect}"
      end

      # Posts a mod log to a mod-log channel if it exists.
      def post
        server = BOT.server(server_id)
        unless server.nil?
          channel = server.channels.find { |c| c.name == 'mod-log' }
          log = []
          log << "**⚠ #{action}** | Case ##{id}"
          log << "**User:** #{BOT.user(offender_id).mention}"
          log << "**Channel:** #{BOT.channel(message.channel_id).mention}" if message
          log << "**Message:** `#{message.message_content}`" if message
          log << "**Reason:** #{reason}"
          log << "**Responsible Modertor:** #{BOT.user(moderator_id).mention}"
          unless channel.nil?
            channel.send_message(log.join("\n"))
          end
        end
      end
    end
  end
end
