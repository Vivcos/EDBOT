module Powerbot
  module DiscordCommands
    module Fortune
      extend Discordrb::Commands::CommandContainer
      command(:fortune, help_available: false) do |event|
        next unless event.channel.private?
        f = `fortune`
        event.channel.send_embed { |e| e.description = f }
      end
    end
  end
end

