module Powerbot
  module DiscordCommands
    module Time
      extend Discordrb::Commands::CommandContainer
      command(:time,
              description: 'displays the current in-game (UTC) time',
              usage: "#{BOT.prefix}time") do |event|
        ::Time.now.strftime "`%H:%M`"
      end
    end
  end
end

