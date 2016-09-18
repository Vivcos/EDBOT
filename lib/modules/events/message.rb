module Powerbot
  module DiscordEvents
    # This event is processed when the bot recieves a message.
    module Ready
      extend Discordrb::EventContainer
      message do |event|
        server_id = event.server.nil? ? 0 : event.server.id
        server_name = event.server.nil? ? 'pm' : event.server.name
        Database::Message.create(
          server_id: server_id,
          server_name: server_name,
          channel_id: event.channel.id,
          channel_name: event.channel.name,
          user_id: event.user.id,
          user_name: event.user.distinct,
          message_id: event.message.id,
          message_content: event.message.content
          attachment_url: event.message.attachments.first.url
        )
      end
    end
  end
end
