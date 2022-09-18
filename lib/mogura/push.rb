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
    DIG_EXT = '.dig'.freeze

    class << self
      def push(project: Rails.application.class.module_parent_name, dags: {})
        upload(gzip(tar(dags)), Mogura.config.endpoint, project, revision)
      end

      private

      def export
        {
          "_export": {
            "rb": {
              "require": Rails.root.join('config/environment').to_s
            }
          }
        }.freeze
      end

      def tar(dags)
        tarfile = StringIO.new("")
        Gem::Package::TarWriter.new(tarfile) do |tar|
          dags.each do |dag_name, dag_content|
            tar.add_file "#{dag_name}#{DIG_EXT}", 33188 do |tf|
              tf.write JSON.pretty_generate(export.merge(dag_content))
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
