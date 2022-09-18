module Mogura
  class Configuration
    attr_accessor :endpoint

    def initialize
      @endpoint = "http://localhost:65432".freeze
    end
  end
end
