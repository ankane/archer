module Archer
  module Coder
    def self.dump(value)
      JSON.generate(value)
    end

    def self.load(value)
      JSON.parse(value, {max_nesting: 1}) unless value.nil?
    rescue JSON::ParserError
      # previous format
      value.split("\n")
    end
  end
end
