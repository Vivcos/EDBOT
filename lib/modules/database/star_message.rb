module Powerbot
  module Database
    class StarMessage < Sequel::Model
      one_to_many :stars

      def before_destroy
        message&.delete
      end

      def starred_message_channel
        BOT.channel(starred_channel_id)
      end

      def starred_message
        starred_message_channel.message(starred_message_id)
      end

      def channel
        BOT.channel(channel_id)
      end

      def message
        channel.message(message_id)
      end

      def author
        BOT.user author_id
      end

      def rep
        stars.count
      end

      def self.user_rep(id)
        where(author_id: id).all.map(&:rep).reduce(:+)
      end

      def star_by(user_id)
        stars.find { |s| s.user_id == user_id }
      end

      def starred_by?(user_id)
        !!star_by(user_id)
      end

      def dead?
        stars.count.zero?
      end
    end

    class Star < Sequel::Model
      many_to_one :star_message
    end
  end
end
