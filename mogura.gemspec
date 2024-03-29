require_relative 'lib/mogura/version'

Gem::Specification.new do |spec|
  spec.name          = "mogura"
  spec.version       = Mogura::VERSION
  spec.authors       = ["KentFujii"]
  spec.email         = ["kent.where.the.light.is@gmail.com"]

  spec.summary       = %q{Digdag bridge for Rails}
  spec.description   = %q{Digdag REST API and Ruby language API bridge for Rails}
  spec.homepage      = "https://github.com/KentFujii/mogura"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency 'fileutils'
end
