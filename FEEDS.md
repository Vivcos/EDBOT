# **PAL's Feed System**

PAL features a minimalist feed system.
This is a feature that lets members of your community "subscribe" to mentions that interest them.

Feeds a bound to a server, to a channel, and a role that is automatically created with the feed.

Abuse of the feed role mention by other users is prevented by pushing content to it with a special "push" command, that briefly makes the role mentionable to send content, then immediately disables role mentions. Essentially, only PAL can mention the role and trigger a notification.

## How to use feeds as a moderator

1. Pick (or create) a channel to bind a feed to.

2. Run `pal.create_feed feed name`, i.e. `pal.create_feed news`. **This binds the feed to the channel you ran the command in and creates the feed role.** Feed names must be unique in your server.

3. Use `pal.push` to send content to the feed. The `push` command can be used from anywhere in the server, like a private channel where the `push` command won't be seen.

### Push command format

`pal.push feed name | post title | post body (| paragraph 1 | paragraph 2..)`

- `feed name` - name of the feed to push to

- `post title` - this will be shown in bold above the post (limit 100 chars)

- `post body` - this is the body of the post. the limit is 2048 characters

Additional pipes (`|`) will break up the post into 'paragraphs' using Discord's embed fields.

You can have up to 25 fields, of 1024 characters each.

Feeds pushes will take on the color of their associated feed role.

**Examples:**

`pal.push memes | dank memes incoming | oh boy, look at those memes :eyes:`


![example](http://imgur.com/DgPHYKi.jpg)

`pal.push memes | dank fields incoming | hey dawg i head you like fields | so have a field | and another one | boi :clap:`

![fields example](http://imgur.com/1gVWM1B.jpg)

## Using feeds as a community member

1. Use `pal.feeds` to get a list of feeds

2. Use `pal.sub feed name` to subscribe to that feed

3. Use `pal.unsub feed name` to unsubscribe

You can see which feeds you're subscribed to by checking your roles.
