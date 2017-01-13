module Powerbot
  module Database
    class Metadata < Sequel::Model
    end

    Metadata.unrestrict_primary_key
  end
end
