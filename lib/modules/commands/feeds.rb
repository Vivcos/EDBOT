module Powerbot
  module DiscordCommands
    module Feeds
      extend Discordrb::Commands::CommandContainer

      # List feeds
      command(:feeds) do |event|
        feeds = Database::Feed.where(server_id: event.server.id).all
        next 'No available feeds..' if feeds.empty?
        event.channel.send_embed(
          'Feeds available in this server:',
          Discordrb::Webhooks::Embed.new(
            description: feeds.map(&:name).join("\n"),
            footer: { text: 'use pal.sub [feed name] to sub to a feed'}
          )
        )
      end

      # Create feed
      command(:create_feed) do |event|
      end

      # Delete a feed
      command(:delete_feed) do |event|
      end

      # Subscribe to feed
      command(:sub) do |event|
      end

      # Unsubscribe from feed
      command(:unsub) do |event|
      end

      # Push content to a feed
      command(:push) do |event|
      end
    end
  end
end
