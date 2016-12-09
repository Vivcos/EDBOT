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

        # Set 'member' literal role to perm level 1
        event.bot.servers.each do |_, server|
          role = server.roles.find { |r| r.name == 'member' }
          unless role.nil?
            event.bot.set_role_permission(role.id, 1)
          end
        end

        # Prevent one-time schedulers from being
        # scheduled again if we reconnect to Discord
        next unless @init
        @init = true

        # Register nightly chat log dump
        SCHEDULER.cron '0 0 * * *' do
          Discordrb::LOGGER.info 'dumping event logs'
          Database::Message.dump
        end
      end
    end
  end
end
