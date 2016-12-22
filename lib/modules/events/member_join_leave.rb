module Powerbot
  module DiscordEvents
    # These events are called when a memeber leaves and joins a server.
    module MemberJoinLeave
      extend Discordrb::EventContainer
      member_join do |event|
        channel = event.server.channels.find { |c| c.name == CONFIG.events_channel }
        unless channel.nil?
          channel.send_embed '', user_embed(event.user, true)
        end
        nil
      end

      member_leave do |event|
        channel = event.server.channels.find { |c| c.name == CONFIG.events_channel }
        unless channel.nil?
          channel.send_embed '', user_embed(event.user, false)
        end
        nil
      end

      module_function

      def user_embed(user, join)
        e = Discordrb::Webhooks::Embed.new
        e.author = {
          name: "#{join ? 'Member Joined' : 'Member Left'}",
          icon_url: "#{join ? 'http://emojipedia-us.s3.amazonaws.com/cache/72/7d/727d10a592ac37ab2844286e0cd70168.png' : 'http://emojipedia-us.s3.amazonaws.com/cache/32/9d/329df0e266f6e63ed5a4be23840b3513.png'}"
        }
        e.color = join ? 0xa8ff99 : 0xff7777
        e.thumbnail = { url: user.avatar_url }
        e.description = "**#{user.distinct}** (#{user.mention})"
        e.footer = { text: user.id.to_s }
        e.timestamp = Time.now
        e
      end
    end
  end
end
