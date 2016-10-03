module Powerbot
  module Database
    # A help entry.
    class HelpEntry < Sequel::Model
      def before_create
        super
        self.timestamp ||= Time.now
      end
    end
  end
end
