module Powerbot
  module DiscordCommands
    # Halp-related commands
    module Halp
      extend Discordrb::Commands::CommandContainer
      # read match
      command(:'halp?',
              permission_level: 1,
              description: 'Queries for help entries',
              usage: "#{BOT.prefix}halp? key") do |event, key|
        results = Database::HelpEntry.where(channel_id: event.channel.id)
                                     .where(Sequel.ilike(:key, "#{key}%"))
        unless results.count.zero?
          title = key.nil? ? '**Halp Entries**' : "**Halp Entries:** `#{key}`"
          event << title
          event << ''
          if results.count > CONFIG.max_halp_results
            keys = results.collect do |r|
              next unless event.channel.id == r.channel_id
              "`#{r.key}:#{r.id}`"
            end.compact.join(', ')
            event << keys
          else
            results.each do |r|
              next unless event.channel.id == r.channel_id
              event << r.composite.to_s if event.channel.id == r.channel_id
            end
          end
          return
        end
        event << 'No entries available in this channel..' if results.empty?
      end

      # read ID
      command(:'halp#',
              permission_level: 1,
              min_args: 1,
              description: 'Prints a help entry with a specific ID',
              usage: "#{BOT.prefix}halp# ID") do |event, id|
        id = id.to_i
        result = Database::HelpEntry.where(channel_id: event.channel.id, id: id).first
        unless result.nil?
          result.composite
        else
          'No entry found by that ID..'
        end
      end

      # create
      command(:'halp!',
              permission_level: 1,
              min_args: 2,
              description: 'Creates new help entries',
              usage: "#{BOT.prefix}halp! key text") do |event, key, *text|
        text = text.join(' ')
        entry = Database::HelpEntry.create(key: key,
                                           text: text,
                                           author_id: event.user.id,
                                           author_name: event.user.distinct,
                                           channel_id: event.channel.id)
        "Created `halp` entry under `#{entry.key}`!"
      end

      # delete
      command(:'halp*',
              permission_level: 3,
              min_args: 1,
              description: 'Removes a help entry by ID',
              usage: "#{BOT.prefix}halp* ID") do |event, id|
        id = id.to_i
        result = Database::HelpEntry.where(channel_id: event.channel.id, id: id).first
        unless result.nil?
          event << "Deleted entry `#{result.key}:#{result.id}`"
          result.destroy
        else
          event << 'No entry found by that ID..'
        end
        nil
      end

      # query
      command(:'halp??',
              permission_level: 1,
              min_args: 1,
              description: 'Get more information about a help entry by ID',
              usage: "#{BOT.prefix}halp?? ID") do |event, id|
        id = id.to_i
        result = Database::HelpEntry.where(channel_id: event.channel.id, id: id).first
        unless result.nil?
          event << '**Halp Entry Metadata**'
          event << "```hs\n#{result.hash_exp.to_yaml}```"
        else
          'No entry found by that ID..'
        end
      end

      # modify
      command(:'halp~',
              permission_level: 1,
              min_args: 2,
              description: 'Modifies a help entry by ID',
              usage: "#{BOT.prefix}halp~ ID text") do |event, id, *text|
        id = id.to_i
        text = text.join(' ')
        result = Database::HelpEntry.where(channel_id: event.channel.id, id: id).first
        unless result.nil?
          if result.author_id == event.user.id
            result.update(text: text)
            event << 'Updated!'
          else
            event << 'You can only modify help entries that you\'ve authored.'
          end
        else
          event << 'No entry found by that ID..'
        end
      end
    end
  end
end
