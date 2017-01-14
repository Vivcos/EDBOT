module Powerbot
  module Database
    class Feed < Sequel::Model
      def server
        BOT.server server_id
      end

      def role
        server.role role_id
      end

      def channel
        server.channel channel_id
      end
    end
  end
end
