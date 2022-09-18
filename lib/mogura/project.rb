require 'rails'
require 'rubygems'
require 'rubygems/package'
require 'zlib'
require 'fileutils'
require 'net/http'
require 'uri'

module Mogura
  module Project
    class Get
      class << self
        def projects
          uri = URI.parse("#{Mogura.config.endpoint}/api/projects")
          response = Net::HTTP.get_response(uri)
          JSON.parse(response.body)
        end

        def project
          # https://docs.digdag.io/api/
          raise NotImplementedError, "You must implement #{self.name}##{__method__}"
        end
      end
    end

    class Put
      class << self
        FILE_MODE = 33188
        DIG_EXT = '.dig'.freeze

        def project(project: Rails.application.class.module_parent_name, dags: [])
          upload(gzip(tar(dags)), Mogura.config.endpoint, project, revision)
        end

        def secret
          # https://docs.digdag.io/api/
          raise NotImplementedError, "You must implement #{self.name}##{__method__}"
        end

        private

        def tar(dags)
          tarfile = StringIO.new("")
          Gem::Package::TarWriter.new(tarfile) do |tar|
            dags.each do |dag|
              tar.add_file "#{dag.name}#{DIG_EXT}", FILE_MODE do |tf|
                tf.write JSON.pretty_generate(dag.content)
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

    class Delete
      class << self
        def project(id:)
          uri = URI.parse("#{endpoint}/api/projects/#{id}")
          request = Net::HTTP::Delete.new(uri)
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
end
