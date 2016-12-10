require 'terminal-table'

module Powerbot
  module DiscordCommands
    # Fetches a random cat picture
    module Cat
      extend Discordrb::Commands::CommandContainer

      # A simple one-way counter
      class Counter
        attr_reader :data

        def initialize
          @data = {}
        end

        def count!(key)
          @data[key] = @data[key].nil? ? 1 : @data[key] + 1
        end

        def count(key)
          @data[key].nil? ? 0 : @data[key]
        end
      end

      CatCounter    = Counter.new
      CatMfwCounter = Counter.new

      bucket :cat, limit: 1, time_span: 30
      command(:cat,
              bucket: :cat,
              rate_limit_message: 'You can summon more cats in %time%'\
                                  ' seconds.',
              help_available: false) do |event|
        break unless event.channel.name == CONFIG.cat_channel
        CatCounter.count! event.user.id
        event.channel.send_message '', nil, cat_embed(event.user)
      end

      command(:'cat.mfw',
              bucket: :cat,
              rate_limit_message: 'You can summon more cats in %time%'\
                                  ' seconds.',
              help_available: false) do |event, *caption|
        break unless event.channel.name == CONFIG.cat_channel
        CatMfwCounter.count! event.user.id
        caption = caption.join ' '
        event.channel.send_message '', nil, cat_embed(event.user, "*#{event.user.display_name}'s face when #{caption}*")
        event.message.delete
      end

      command(:'cat.stats', help_available: false) do |event|
        break unless event.channel.name == CONFIG.cat_channel
        cat_total = CatCounter.count event.user.id
        cat_mfw_total = CatMfwCounter.count event.user.id
        "You've summoned `#{cat_total + cat_mfw_total}` cats #{%w(😻 😸 😼 🙀 😹).sample}"\
        " `cat: #{cat_total} | cat_mfw: #{cat_mfw_total}`"
      end

      command(:'cat.board', help_available: false) do |event|
        break unless event.user.id == CONFIG.owner
        messages = Database::Message.all.clone
        users = messages.collect(&:user_id).uniq
        placing = 0
        data = users.collect do |id|
          message_set = messages.select { |m| m.user_id == id }
          cat =     message_set.select { |m| m.message_content == 'pal.cat' }.count
          cat_mfw = message_set.select { |m| m.message_content[/^pal\.cat\.mfw.*/] }.count
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

      def cat_embed(author = nil, text = '')
        e = Discordrb::Webhooks::Embed.new
        e.author = { name: author.name, icon_url: author.avatar_url } if author
        e.description = text
        e.image = { url: cat }
        e.footer = {
          text: "cat: #{CatCounter.count author.id} /"\
                " cat.mfw: #{%w(😻 😸 😼 🙀 😹).sample} #{CatMfwCounter.count author.id}"
        }
        e
      end
    end
  end
end
