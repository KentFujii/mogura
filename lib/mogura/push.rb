require 'rails'
require 'rubygems'
require 'rubygems/package'
require 'zlib'
require 'fileutils'
require 'net/http'
require 'uri'
require 'jbuilder'

module Mogura
  class Push
    DEFAULT_PROJECT = Rails.application.class.module_parent_name.freeze
    DIG_EXT = '.dig'.freeze
    RESERVED_EXPORT = {
      "_export": {
        "rb": {
          "require": Rails.root.join('config/environment').to_s
        }
      }
    }.freeze

    class << self
      def push(project: DEFAULT_PROJECT, dags: {})
        require File.expand_path('config/environment') unless ENV['environment'] == 'test'
        upload(gzip(tar(dags)), Mogura.config.endpoint, project, revision)
      end

      private

      def tar(dags)
        tarfile = StringIO.new("")
        Gem::Package::TarWriter.new(tarfile) do |tar|
          dags.each do |dag_name, dag_content|
            tar.add_file dag_name, mode do |tf|
              tf.write JSON.pretty_generate(RESERVED_EXPORT.merge(dag_content))
            end
          end
        end
        tarfile
      end

      def gzip(tarfile)
        gz = StringIO.new("")
        z = Zlib::GzipWriter.new(gz)
        z.write tarfile.string
        z.close
        StringIO.new(gz.string, binmode: true)
      end

      def revision
        SecureRandom.hex(10)
      end

      def upload(gzip, endpoint, project, revision)
        uri = URI.parse("#{endpoint}/api/projects?project=#{project}&revision=#{revision}")
        request = Net::HTTP::Put.new(uri)
        request.content_type = "application/gzip"
        request.body = gzip.read
        req_options = {
          use_ssl: uri.scheme == "https",
        }
        Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
      end
    end
  end
end
