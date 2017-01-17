module Powerbot
  module DiscordCommands
    # Responds with "Pong!".
    # This used to check if bot is alive
    module Ping
      extend Discordrb::Commands::CommandContainer
      command(:ping,
              description: 'checks if bot is alive',
              usage: "#{BOT.prefix}ping",
              help_available: false,
              permission_level: 4) do |event|
        "`#{::Time.now - event.timestamp} ms`"
      end
    end
  end
end
