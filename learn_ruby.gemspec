require_relative "lib/learn_ruby/version"

Gem::Specification.new do |spec|
  spec.name        = "learn_ruby"
  spec.version     = LearnRuby::VERSION
  spec.authors     = [ "Jayesh" ]
  spec.email       = [ "jayeshborkar5868@gmail.com" ]
  spec.homepage    = "https://github.com/jayesh/learn_ruby"
  spec.summary     = "Interactive Ruby learning roadmap and compiler playground for Rails devs"
  spec.description = "A mountable Rails engine gem providing interactive Ruby lessons, a visual roadmap, code playground, and inline test validation."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jayesh/learn_ruby"
  spec.metadata["changelog_uri"] = "https://github.com/jayesh/learn_ruby/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.3"
end
