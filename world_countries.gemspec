Gem::Specification.new do |spec|
  spec.name          = "devme-world-countries"
  spec.version       = "1.0.0"
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["DEV.ME Team"]
  spec.email         = ["support@dev.me"]

  spec.summary       = "Comprehensive world countries data - REST Countries v3.1 compatible"
  spec.description   = "A Ruby library providing comprehensive world countries data including names, codes, capitals, currencies, languages, timezones, flags, and more. Compatible with REST Countries v3.1 format."
  spec.homepage      = "https://github.com/devmehq/world-countries"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/devmehq/world-countries"
  spec.metadata["changelog_uri"] = "https://github.com/devmehq/world-countries/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/devmehq/world-countries/issues"
  spec.metadata["documentation_uri"] = "https://github.com/devmehq/world-countries#readme"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("{src/ruby,data}/**/*") + %w[README.md LICENSE CHANGELOG.md]
  spec.require_paths = ["src/ruby"]

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "simplecov", "~> 0.22"
end