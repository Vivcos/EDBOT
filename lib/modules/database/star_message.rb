module Powerbot
  module Database
    class StarMessage < Sequel::Model
      one_to_many :stars

      def starred_message
        BOT.channel(starred_channel_id, starred_message_id)
      end

      def message
        BOT.channel(channel_id).message(message_id)
      end

      def rep
        stars.count
      end

      def star_by(user_id)
        stars.find { |s| s.user_id == user_id }
      end

      def starred_by?(user_id)
        !!star_by(user_id)
      end
    end

    class Star < Sequel::Model
      many_to_one :star_message
    end
  end
end
