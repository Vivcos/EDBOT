module Powerbot
  module Database
    class Feed < Sequel::Model
      def before_create
        role         = server.create_role
        role.name    = name
        role.packed  = 0
        self.role_id = role.id
      end

      def before_destroy
        role.delete
      end

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
