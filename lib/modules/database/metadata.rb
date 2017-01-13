module Powerbot
  module Database
    class Metadata < Sequel::Model
      def self.from_hash(snowflake, data)
        create snowflake: snowflake, data: data.to_json
      end

      def read
        JSON.parse data
      end

      def write(hash)
        update data: hash.to_json
      end
    end

    Metadata.unrestrict_primary_key
  end
end
