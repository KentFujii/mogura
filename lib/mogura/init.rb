require 'rails'

module Mogura
  class Init
    CONFIG_PATH = 'config/digdag'.freeze
    APP_PATH = 'app/dags'.freeze

    class << self
      def init
        require File.expand_path('config/environment') unless ENV['environment'] == 'test'
        init_dig
        init_dag
      end

      private

      def init_dig
        Dir.mkdir(Rails.root.join('config/digdag').to_s)
        out_file = File.new(Rails.root.join("#{CONFIG_PATH}/sample.dig").to_s, "w")
        out_file.puts(dig_sample_content)
        out_file.close
      end

      def init_dag
        Dir.mkdir(Rails.root.join('app/dags').to_s)
        out_sample_file = File.new(Rails.root.join("#{APP_PATH}/sample_dag.rb").to_s, "w")
        out_sample_file.puts(dag_sample_content)
        out_sample_file.close
      end

      def dig_sample_content
        <<~TEXT
          _export:
            rb:
              require: #{Rails.root.join('config/environment').to_s}
          +run:
            rb>: SampleDag.run
        TEXT
      end

      def dag_sample_content
        <<~TEXT
          class SampleDag
            def run
              puts "Hello Rails \#{Rails.env}"
            end
          end
        TEXT
      end
    end
  end
end
