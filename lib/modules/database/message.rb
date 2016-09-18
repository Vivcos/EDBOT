module Powerbot
  module Database
    # A Discord message
    class Message < Sequel::Model
      # Set timestamp before creation
      def before_create
        super
        self.timestamp = Time.now
      end

      # Log creation
      def after_create
        Discordrb::LOGGER.info "created message: #{inspect}"
      end

      # Fetch message from cache
      def message
        BOT.channel(channel_id).message(message_id)
      end

      # Was a message deleted?
      def deleted?
        message.nil?
      end

      # Dump all messages to a file
      def self.dump
        file = File.open("data/logs/#{Time.now.strftime('%s')}.tsv", 'w')
        data = all.collect do |m|
          "#{m.timestamp}\t"\
          "#{m.server_name}\t"\
          "#{m.channel_name}\t"\
          "#{m.user_name}\t"\
          "#{m.message_content}\t"\
          "#{m.attachment_url}"
        end.join("\n")
        file.write(data)
        file.close
      end
    end
  end
end
