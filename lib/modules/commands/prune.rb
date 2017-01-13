module Powerbot
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

      command(:prune_to,
              description: 'clears a channel of messages, up to the ID you specify',
              usage: "#{BOT.prefix}prune_to 12345678",
              help_available: false,
              permission_level: 4) do |event, id|
        m = event.channel.message id
        next 'Invalid message ID' unless m
        messages = event.channel.history(100).take_while { |h| h.id != id.to_i }
        event.channel.delete_messages messages
      end
    end
  end
end
