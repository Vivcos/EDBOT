require 'time_difference'

module Powerbot
  module DiscordCommands
    module UserInfo
      extend Discordrb::Commands::CommandContainer

      command([:ui, :user_info],
              description: 'shows you information about yourself or another member',
              usage: "#{BOT.prefix}user_info") do |event|
        next 'This command can only be used in servers.' if event.channel.private?

        member   = event.message.mentions.first unless event.message.mentions.empty?
        member ||= event.user

        member = member.on(event.server) if member.is_a? Discordrb::User

        event.channel.send_embed do |e|
          e.author = {
            name: member.nick.nil? ? member.distinct : "#{member.distinct} (#{member.nick})",
          }

          e.thumbnail = { url: member.avatar_url }

          e.color = member.roles.sort_by(&:position).last.color.combined

          time = TimeDifference.between(::Time.now, member.joined_at)
                               .humanize
                               .sub(/\sand.*/, '')

          e.add_field(
            name: 'Member since',
            inline: false,
            value: "#{member.joined_at.strftime('%Y-%m-%d')} (#{time})"
          )

          e.add_field(
            name: 'Joined Discord',
            inline: true,
            value: member.creation_time.strftime('%Y-%m-%d')
          )

          e.add_field(
            name: 'Roles',
            inline: true,
            value: member.roles.map { |r| "`#{r.name}`" }.join(', ')
          )

          e.footer = { text: event.server.name, icon_url: event.server.icon_url }

          e.timestamp = ::Time.now
        end
      end
    end
  end
end
