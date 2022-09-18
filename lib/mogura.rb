require "mogura/version"
require "mogura/builder"
require "mogura/configuration"
require "mogura/project"

module Mogura
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end
end
