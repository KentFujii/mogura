require 'rails'
require 'fileutils'

module Mogura
  class Init
    DIG_PATH = 'app/views'.freeze
    DAG_PATH = 'app/dags'.freeze
    DEFAULT_PROJECT = 'sample'.freeze

    class << self
      def init(project: DEFAULT_PROJECT)
        @project = project
        require File.expand_path('config/environment') unless ENV['environment'] == 'test'
        generate_dig_file
        generate_dag_file
      end

      private

      def generate_dig_file
        FileUtils.mkdir_p(Rails.root.join("#{DIG_PATH}/#{@project.underscore}").to_s)
        out_file = File.new(Rails.root.join("#{DIG_PATH}/#{@project.underscore}_dag/sample.json.jbuilder").to_s, "w")
        out_file.puts(dig_sample_content)
        out_file.close
      end

      def generate_dag_file
        FileUtils.mkdir_p(Rails.root.join(DAG_PATH).to_s)
        out_sample_file = File.new(Rails.root.join("#{DAG_PATH}/#{@project.underscore}.rb").to_s, "w")
        out_sample_file.puts(dag_sample_content)
        out_sample_file.close
      end

      def dig_sample_content
        <<~TEXT
          json.set! '_export' do
            json.rb do
              json.require Rails.root.join('config/environment').to_s
            end
          end

          json.set! '+run' do
            json.set! 'rb>', '#{@project.camelize}.sample_task'
          end
        TEXT
      end

      def dag_sample_content
        <<~TEXT
          class #{@project.camelize}
            def sample_task
              puts "Hello Rails \#{Rails.env}"
            end
          end
        TEXT
      end
    end
  end
end
