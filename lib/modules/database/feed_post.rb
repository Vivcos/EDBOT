module Powerbot
  module Database
    class FeedPost < Sequel::Model
      many_to_one :feed

      def message
        feed.channel.message message_id
      end
    end
  end
end
