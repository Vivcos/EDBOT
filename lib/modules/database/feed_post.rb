module Powerbot
  module Database
    class FeedPost < Sequel::Model
      many_to_one :feed
    end
  end
end
