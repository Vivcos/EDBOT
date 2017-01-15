module Powerbot
  module DiscordCommands
    # Commands for managing a server's Starboard
    module Starboard
      extend Discordrb::Commands::CommandContainer

      # Link the starboard channel
      command(:'starboard.link', permission_level: 3, help_available: false) do |event, channel_id|
        server_options = Database::Metadata[event.server.id]
        server_options ||= Database::Metadata.from_hash event.server.id, {}

        server_options.merge({ star_channel_id: channel_id.to_i })

        '🆗'
      end

      # Toggles allowing messages to be starred in the channel its run in
      command(:'allow_stars', permission_level: 3, help_available: false) do |event|
        channel_options = Database::Metadata[event.channel.id]
        channel_options ||= Database::Metadata.from_hash event.channel.id, {}

        current_option = channel_options.read['allow_stars']

        channel_options.merge({ allow_stars: !current_option })

        '🆗'
      end
    end
  end
end
