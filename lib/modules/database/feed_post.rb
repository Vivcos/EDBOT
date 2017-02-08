module Powerbot
  module Database
    class FeedPost < Sequel::Model
      many_to_one :feed

      def message
        feed.channel.message message_id
      end

      def author
        BOT.user author_id
      end

      def tagline
        "🛰️ #{role.mention} **| #{title}**"
      end

      def parse_content
        data = content.split '|'

        fields = data.map do |f|
          Discordrb::Webhooks::Field.new(
            name: "\u200b",
            value: f
          )
        end

        Discordrb::Webhooks::Embed.new(
          description: data.first,
          fields: fields,
          color: feed.role.color.combined,
          footer: {
            text: "#{author.distinct} [use 'pal.unsub #{feed.name}' to unsub] | ##{id}",
            icon_url: author.avatar_url
          },
          timestamp: Time.now
        )
      end
    end
  end
end
