module Powerbot
  module DiscordEvents
    # This event is processed when the bot connects to Discord.
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        # Configure bot
        event.bot.profile.avatar = File.open(CONFIG.avatar)
        event.bot.game = CONFIG.game

        # Set owner permission level
        event.bot.set_user_permission(CONFIG.owner, 4)

        # Register nightly chat log dump
        SCHEDULER.cron '0 0 * * *' do
          Discordrb::LOGGER.info 'dumping event logs'
          Database::Message.dump
        end
      end
    end
  end
end
