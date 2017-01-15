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
          update_star(maybe_existing_star)
        else

          next if event.message.author == event.user

          channel_options = Database::Metadata[event.channel.id]&.read
          server_options = Database::Metadata[event.channel.server.id]&.read

          next unless channel_options && server_options
          next unless channel_options['allow_stars'] && server_options['star_channel_id']

          star_channel_id = Database::Metadata[event.channel.server.id]&.read['star_channel_id']

          star_message = Database::StarMessage.create(
            starred_channel_id: event.channel.id,
            starred_message_id: event.message.id,
            channel_id: star_channel_id
          )

          star_message.add_star user_id: event.user.id

          update_star(star_message)
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

        next maybe_existing_star.destroy if maybe_existing_star.rep == 1
        update_star Database::StarMessage[maybe_existing_star.id]
      end

      module_function

      def update_star(star)
        rep = star.rep > 1 ? "**#{star.rep}**" : ''
        star_string = "#{STAR_EMOJI} #{rep} #{star.starred_message_channel.mention}"

        if star.message
          star.message.edit(
            star_string,
            star_embed(star)
          )
        else
          message = star.channel.send_embed(
            star_string,
            star_embed(star)
          )

          star.update message_id: message.id
        end
      end

      def star_embed(star)
        message = star.starred_message
        author = message.author
        Discordrb::Webhooks::Embed.new(
          description: message.content,
          author: { name: author.display_name, icon_url: author.avatar_url },
          timestamp: message.timestamp,
          color: 0xffff00
        )
      end
    end
  end
end
