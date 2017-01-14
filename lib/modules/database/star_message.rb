module Powerbot
  module Database
    class StarMessage < Sequel::Model
      one_to_many :stars
    end

    class Star < Sequel::Model
      many_to_one :star_message
    end
  end
end
