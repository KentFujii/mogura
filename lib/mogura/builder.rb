module Mogura
  module Builder
    class Dag
      class << self
        def build(name: '', tasks: {})

          dag = Struct.new("Dag", :name, :tasks) do
            def content
              export = {
                "_export": {
                  "rb": {
                    "require": Rails.root.join('config/environment').to_s
                  }
                }
              }.freeze
              JSON.pretty_generate(export.merge(tasks))
            end
          end
          dag.new(name, tasks)
        end
      end
    end
  end
end
