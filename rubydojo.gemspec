require_relative "lib/rubydojo/version"

Gem::Specification.new do |spec|
  spec.name        = "rubydojo"
  spec.version     = Rubydojo::VERSION
  spec.authors     = [ "Jayesh" ]
  spec.email       = [ "jayeshborkar5868@gmail.com" ]
  spec.homepage    = "https://github.com/jayesh/rubydojo"
  spec.summary     = "Interactive Ruby learning roadmap and compiler playground for Rails devs"
  spec.description = "A mountable Rails engine gem providing interactive Ruby lessons, a visual roadmap, code playground, and inline test validation."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["source_code_uri"] = "https://github.com/jayesh/rubydojo"
  spec.metadata["changelog_uri"] = "https://github.com/jayesh/rubydojo/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "~> 8.1", ">= 8.1.3"
end
