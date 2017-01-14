module Powerbot
  module DiscordEvents
    module Star
      extend Discordrb::EventContainer

      STAR_EMOJI = "\u2B50".freeze

      # Star a message
      reaction_add(emoji: STAR_EMOJI) do |event|
        # Below is fixed in a pull request
        break unless event.emoji.name == STAR_EMOJI
        maybe_existing_star = Database::StarMessage.find(
          starred_channel_id: event.channel.id,
          starred_message_id: event.message.id
        )

        if maybe_existing_star
          maybe_existing_star.add_star user_id: event.user.id unless maybe_existing_star.starred_by?(event.user)
        else

          next if event.message.author == event.user

          next unless Database::Metadata[event.channel.id]&.read['allow_stars']

          star_channel_id = Database::Metadata[event.server.id]&.read['star_channel_id']
          next unless star_channel_id

          star_message = Database::StarMessage.create(
            starred_channel_id: event.channel.id,
            starred_message_id: event.message.id
          )

          star_message.add_star user_id: event.user.id
        end
      end

      # Unstar a message
      reaction_remove(emoji: STAR_EMOJI) do |event|
        # Below is fixed in a pull request
        break unless event.emoji.name == STAR_EMOJI
        maybe_existing_star = Database::StarMessage.find(
          starred_channel_id: event.channel.id,
          starred_message_id: event.message.id
        )

        next unless maybe_existing_star

        user_star = maybe_existing_star.star_by(event.user.id)
        user_star.destroy if user_star

        maybe_existing_star.destroy if maybe_existing_star.rep == 1
      end

      module_function

      def star_embed(star)
        message = star.starred_message
        author = message.author
        Discordrb::Webhooks::Embed.new(
          description: starred_message.content,
          author: { name: author.display_name, icon_url: author.avatar_url },
          timestamp: message.timestamp,
          color: 0xffff00
        )
      end
    end
  end
end
