module Bot
  module DiscordEvents
    # This event is processed when the bot connects to Discord.
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        event.bot.profile.avatar = File.open(CONFIG.avatar)
        event.bot.game = CONFIG.game
      end
    end
  end
end
