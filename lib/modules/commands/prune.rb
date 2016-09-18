module Bot
  module DiscordCommands
    # Prunes (deletes) messages from a channel.
    # The maximum is 100 messages at once.
    module Prune
      extend Discordrb::Commands::CommandContainer
      command(:prune,
              description: 'clears a channel of messages',
              usage: "#{BOT.prefix}prune number_of_messages",
              help_available: false,
              permission_level: 4) do |event, number|
        number = number.nil? ? 100 : number.to_i
        if event.bot.profile.on(event.server).can_manage_messages?
          event.channel.prune(number)
          return
        end
        '❌'
      end
    end
  end
end
