require 'terminal-table'

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
        break unless event.channel.name == CONFIG.cat_channel
        cat
      end

      command(:cat_mfw,
              bucket: :cat,
              rate_limit_message: 'You can summon more cats in %time%'\
                                  ' seconds.',
              help_available: false) do |event, *caption|
        break unless event.channel.name == CONFIG.cat_channel
        event << "`#{event.user.display_name}'s face when #{caption.join(' ')}`"
        event << cat
        event.message.delete
      end

      command(:cat_stats, help_available: false) do |event|
        break unless event.channel.name == CONFIG.cat_channel
        messages =  Database::Message.where(user_id: event.user.id)
        cat = messages.where(message_content: 'pal.cat').count
        cat_mfw = messages.where(Sequel.ilike(:message_content, 'pal.cat_mfw%')).count
        "You've summoned `#{cat + cat_mfw}` cats #{%w(😻 😸 😼 🙀 😹).sample}"\
        " `cat: #{cat} | cat_mfw: #{cat_mfw}`"
      end

      command(:cat_board, help_available: false) do |event|
        break unless event.user.id == CONFIG.owner
        messages = Database::Message.all.clone
        users = messages.collect(&:user_id).uniq
        placing = 0
        data = users.collect do |id|
          message_set = messages.select { |m| m.user_id == id }
          cat =     message_set.select { |m| m.message_content == 'pal.cat' }.count
          cat_mfw = message_set.select { |m| m.message_content[/^pal.cat_mfw.*/] }.count
          total = cat + cat_mfw
          next if total.zero?
          { name: message_set.first.user_name, cat: cat, mfw: cat_mfw, total: total }
        end.compact.sort_by { |h| h[:total] }
           .reverse
           .map! { |m| [placing += 1, m[:name], m[:cat], m[:mfw], m[:total]] }
           .take(10)
        headings = %w(# Name cat cat_mfw total)
        event << "**Catreus Caturday Leaderboard** #{%w(😻 😸 😼 🙀 😹).sample}"\
                 " `#{Time.now}`"
        event << "```hs"
        event << "#{Terminal::Table.new headings: headings, rows: data}"
        event << "```"
      end

      module_function

      def cat
        JSON.parse(RestClient.get('http://random.cat/meow'))['file'].gsub('.jpg','')
      end
    end
  end
end
