# Gems
require 'discordrb'
require 'yaml'
require 'json'
require 'rufus-scheduler'
require 'pry'

# The main bot module.
module Powerbot
  # Bot configuration
  CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'

  # Load non-Discordrb modules
  Dir['lib/modules/*.rb'].each { |mod| load mod }

  # Event scheduler
  SCHEDULER = Rufus::Scheduler.new

  # Create the bot.
  # The bot is created as a constant, so that you
  # can access the cache anywhere.
  BOT = Discordrb::Commands::CommandBot.new(client_id: CONFIG.client_id,
                                            token: CONFIG.token,
                                            prefix: CONFIG.prefix,
                                            help_command: :halp)

  # Discord commands
  module DiscordCommands; end
  Dir['lib/modules/commands/*.rb'].each { |mod| load mod }
  DiscordCommands.constants.each do |mod|
    BOT.include! DiscordCommands.const_get mod
  end

  # Discord events
  module DiscordEvents; end
  Dir['lib/modules/events/*.rb'].each { |mod| load mod }
  DiscordEvents.constants.each do |mod|
    BOT.include! DiscordEvents.const_get mod
  end

  # Run the bot
  BOT.run :async

  binding.pry

  BOT.sync
end
