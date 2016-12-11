module Powerbot
  module DiscordCommands
    # Commands related to the Traikoa API
    module Traikoa
      extend Discordrb::Commands::CommandContainer

      # Displays system metadata
      command(:info,
              permission_level: 1,
              description: 'Displays info about a system',
              usage: "#{BOT.prefix}info (system name)",
              ) do |event, *name|
        name = name.join ' '
        sys = Powerbot::Traikoa::System.search(name).first
        next 'System not found..' unless sys
        event.channel.send_message '', nil, system_embed(sys)
      end

      # Displays a collection of distances to multiple systems
      # from a singular origin point
      command(:distance,
              permission_level: 1,
              description: 'Get the distance between one or more systems',
              usage: "#{BOT.prefix}distance system_a, system_b...",) do |event, *names|
        names = names.join(' ').split(',').map(&:strip)
        next 'Please specify two or more systems.' unless names.count > 1

        origin = Powerbot::Traikoa::System.search(names.shift).first
        next 'Origin not found..' unless origin

        systems = names.map { |n| Powerbot::Traikoa::System.search(n).first }

        systems.each_with_index do |s, i|
          event << "System not found: `#{names[i]}`" if s.nil?
          next if s.nil?
          event << "`#{origin.name} → #{s.name} : #{origin.distance(s).round 2} ly`"
        end
        nil
      end

      # Displays the shortest distance route
      # between a collection of systems
      command(:route,
              permission_level: 1,
              description: 'Get the shortest-distance route between a collection of systems',
              usage: "#{BOT.prefix}route system_a, system_b...",) do |event, *names|
        names = names.join(' ').split(',').map(&:strip)
        next 'Please specify three or more systems.' unless names.count > 2

        systems = names.map { |n| Powerbot::Traikoa::System.search(n).first }.compact

        systems.sort! do |a, b|
          next -1 if a == systems.first
          distance_a = systems.map { |s| s.distance a unless a == s }.compact.min
          distance_b = systems.map { |s| s.distance b unless b == s }.compact.min
          distance_a <=> distance_b
        end

        systems.each_with_index do |s, i|
          nex = systems[i + 1]
          event << "`#{s.name} → #{nex.name} (#{s.distance(nex).round 2} ly)`" if nex
        end
        nil
      end

      module_function

      def system_embed(sys)
        e = Discordrb::Webhooks::Embed.new
        e.title = "🌟 #{sys.name}"
        e.colour = 0xFCCB0D
        e.add_field(
          name: 'Info',
          value: "Population: #{sys.population}\n"\
                 "Allegiance: #{sys.allegiance}\n"\
                 "Security: #{sys.security}\n"\
                 "Permit locked: #{sys.permit? ? 'Yes' : 'No'}\n"\
                 "CC value: #{sys.cc_value}\n"\
                 "Contested: #{sys.contested? ? 'Yes' : 'No' }\n",
          inline: true
        )
        e.add_field(
          name: 'Stations',
          value: sys.stations.map { |s| "[#{s[:pad_size]}] #{s[:name]}, #{s[:distance].nil? ? '?' : s[:distance]}ls #{s[:is_planetary] ? '(planetary)' : ''}" }.join("\n"),
          inline: true
        ) if sys.stations.any?
        e.footer = { text: "id: #{sys.id} x: #{sys.x} y: #{sys.y} z: #{sys.z}" }
        e
      end
    end
  end
end
