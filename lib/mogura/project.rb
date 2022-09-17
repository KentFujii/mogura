module Mogura
  class Project
    class << self
      def projects
        uri = URI.parse("#{Mogura.config.endpoint}/api/projects")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
      end
    end
  end
end
