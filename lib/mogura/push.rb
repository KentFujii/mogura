require 'rails'
require 'rubygems'
require 'rubygems/package'
require 'zlib'
require 'fileutils'
require 'net/http'
require 'uri'

module Mogura
  class Push
    DEFAULT_ENDPOINT = 'http://localhost:65432'.freeze

    class << self
      def push(endpoint: DEFAULT_ENDPOINT)
        require File.expand_path('config/environment') unless ENV['environment'] == 'test'
        upload(gzip(tar(path)), endpoint, project, revision)
      end

      private

      def path
        Rails.root.join('config/digdag').to_s
      end

      def tar(path)
        tarfile = StringIO.new("")
        Gem::Package::TarWriter.new(tarfile) do |tar|
          Dir[File.join(path, "**/*")].each do |file|
            mode = File.stat(file).mode
            relative_file = file.sub /^#{Regexp::escape path}\/?/, ''

            if File.directory?(file)
              tar.mkdir relative_file, mode
            else
              tar.add_file relative_file, mode do |tf|
                File.open(file, "rb") { |f| tf.write f.read }
              end
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

      def project
        Rails.application.class.module_parent_name
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
