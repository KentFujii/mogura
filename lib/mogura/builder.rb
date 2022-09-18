require 'ostruct'

module Mogura
  module Builder
    class Dag
      class << self
        def build(name: '', content: {})
          export ={
            "_export": {
              "rb": {
                "require": Rails.root.join('config/environment').to_s
              }
            }
          }.freeze
          OpenStruct.new(
            name: name,
            content: export.merge(content)
          )
        end
      end
    end
  end
end
