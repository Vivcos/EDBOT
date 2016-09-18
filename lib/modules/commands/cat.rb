module Powerbot
  module DiscordCommands
    # Fetches a random cat picture
    module Cat
      extend Discordrb::Commands::CommandContainer
      bucket :cat, limit: 1, time_span: 60
      command(:cat,
              bucket: :cat,
              rate_limit_message: 'You can summon more cats in %time%'\
                                  ' seconds.',
              help_available: false) do |event|
        break unless event.channel.name == CONFIG.general_channel
        cat
      end

      command(:cat_mfw,
              bucket: :cat,
              rate_limit_message: 'You can summon more cats in %time%'\
                                  ' seconds.',
              help_available: false) do |event, *caption|
        break unless event.channel.name == CONFIG.general_channel
        event << "`#{event.user.display_name}'s face when #{caption.join(' ')}`"
        event << cat
        event.message.delete
      end

      command(:cat_stats, help_available: false) do |event|
        break unless event.channel.name == CONFIG.general_channel
        messages =  Database::Message.where(user_id: event.user.id)
        cat = messages.where(message_content: 'pal.cat').count
        cat_mfw = messages.where(Sequel.ilike(:message_content, 'pal.cat_mfw%')).count
        "You've summoned `#{cat + cat_mfw}` cats #{['😻','😸','😼','🙀','😹'].sample}"\
        " `cat: #{cat} | cat_mfw: #{cat_mfw}`"
      end

      module_function

      def cat
        JSON.parse(RestClient.get('http://random.cat/meow'))['file'].gsub('.jpg','')
      end
    end
  end
end
