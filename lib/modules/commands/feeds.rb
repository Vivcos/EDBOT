module Powerbot
  module DiscordCommands
    module Feeds
      extend Discordrb::Commands::CommandContainer

      # List feeds
      command(:feeds,
              description: 'List available feeds',
              usage: "#{BOT.prefix}feeds") do |event|
        next if event.channel.pm?
        feeds = Database::Feed.where(server_id: event.server.id).all
        next 'No available feeds..' if feeds.empty?
        event.channel.send_embed(
          'Feeds available in this server:',
          Discordrb::Webhooks::Embed.new(
            description: feeds.map(&:name).join("\n"),
            footer: { text: 'use pal.sub [feed name] to sub to a feed'}
          )
        )
      end

      # Create feed
      command(:create_feed,
              description: 'Create a new feed bound to THIS channel.',
              usage: "#{BOT.prefix}create_feed memes",
              permission_level: 3) do |event, *name|
        next if event.channel.pm?
        name = name.join ' '

        maybe_existing_feed = Database::Feed.find server_id: event.server.id, name: name
        next 'Feed already exists!' if maybe_existing_feed

        Database::Feed.create(
          server_id: event.server.id,
          channel_id: event.channel.id,
          name: name
        )

        '👌'
      end

      # Delete a feed
      command(:delete_feed,
              description: 'Deletes a feed and its associated role',
              usage: "#{BOT.prefix}delete_feed memes",
              permission_level: 3) do |event, *name|
        next if event.channel.pm?
        name = name.join ' '

        maybe_existing_feed = Database::Feed.find server_id: event.server.id, name: name
        next 'Feed not found..' unless maybe_existing_feed

        maybe_existing_feed.destroy

        '👌'
      end

      # Subscribe to feed
      command(:sub,
              description: 'Subscribes you to recieve mentions from this feed',
              usage: "#{BOT.prefix}sub memes",
              permission_level: 1) do |event, *name|
        next if event.channel.pm?
        name = name.join ' '

        maybe_existing_feed = Database::Feed.find server_id: event.server.id, name: name
        next 'Feed not found. Use `pal.feeds` for a list of feeds.' unless maybe_existing_feed

        role = maybe_existing_feed.role

        if event.user.role? role
          'You\'re already subscribed to this feed.'
        else
          event.user.add_role role
          '👌'
        end
      end

      # Unsubscribe from feed
      command(:unsub,
              description: 'Unsubscribes you from a feed',
              usage: "#{BOT.prefix}unsub memes",
              permission_level: 1) do |event, *name|
        next if event.channel.pm?
        name = name.join ' '

        maybe_existing_feed = Database::Feed.find server_id: event.server.id, name: name
        next 'Feed not found. Use `pal.feeds` for a list of feeds.' unless maybe_existing_feed

        role = maybe_existing_feed.role

        if event.user.role? role
          event.user.remove_role role
          '👌'
        else
          'You\'re not subscribed to that feed.'
        end
      end

      # Push content to a feed
      command(:push,
              description: 'Publishes content to a feed',
              usage: "#{BOT.prefix}push feed name | title | content",
              permission_level: 3) do |event|
        next if event.channel.pm?
        args = event.message.content[8..-1]
                    .split('|')
                    .map(&:strip)

        next 'Not enough arguments. Format: `pal.push feed | title | content`' if args.count < 3

        name    = args.shift
        title   = args.shift
        content = args.join '|'

        maybe_existing_feed = Database::Feed.find server_id: event.server.id, name: name
        next 'Feed not found. Use `pal.feeds` for a list of feeds.' unless maybe_existing_feed
        next "Title too long (#{content.length} / 100)" if title.length > 100
        next 'Content too long' if content.length > 2048
        next "Too many fields (#{fields.count} / 25)" if content.count('|') > 25

        post = maybe_existing_feed.add_feed_post(
          title: title,
          author_id: event.user.id,
          content: content
        )
        post.update_post

        m = event.respond '👌'

        sleep 3

        event.channel.delete_messages [m, event.message]

        nil
      end

      # Edit a feed post
      command(:edit,
              description: 'Edits an existing feed post',
              usage: "#{BOT.prefix}edit 1 new content",
              permission_level: 3) do |event, post_id, *content|
        post_id = post_id.delete('#').to_i

        content = content.join ' '
        next 'Content too long' if content.length > 2048
        next "Too many fields (#{fields.count} / 25)" if content.count('|') > 25

        post = Database::FeedPost.find id: post_id
        next 'Post not found with that ID..' unless post

        post.update content: content, author_id: event.user.id
        post.update_post

        m = event.respond '👌'

        sleep 3

        event.channel.delete_messages [m, event.message]

        nil
      end
    end
  end
end
