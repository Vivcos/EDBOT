module Powerbot
  module DiscordEvents
    # This event is processed when the bot connects to Discord.
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        event.bot.profile.avatar = File.open(CONFIG.avatar)
        event.bot.game = CONFIG.game

        event.bot.set_user_permission(CONFIG.owner, 4)
      end
    end
  end
end
