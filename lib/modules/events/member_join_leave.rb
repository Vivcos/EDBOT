module Powerbot
  module DiscordEvents
    # These events are called when a memeber leaves and joins a server.
    module MemberJoinLeave
      extend Discordrb::EventContainer
      member_join do |event|
        channel = event.server.channels.find { |c| c.name == CONFIG.events_channel }
        unless channel.nil?
          channel.send_message("**#{event.user.mention} has joined #{event.server.name}!** 🎉")
        end
      end

      member_leave do |event|
        channel = event.server.channels.find { |c| c.name == CONFIG.events_channel }
        unless channel.nil?
          channel.send_message("**#{event.user.mention} has left #{event.server.name}!** 😕")
        end
      end
    end
  end
end
