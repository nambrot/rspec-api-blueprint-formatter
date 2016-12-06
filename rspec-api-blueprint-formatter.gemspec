# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rspec-api-blueprint-formatter"
  spec.version       = ApiBlueprint::VERSION
  spec.authors       = ["Nam Chu Hoai"]
  spec.email         = ["nambrot@googlemail.com"]

  spec.summary       = %q{Use your Rspec tests to build your API documentation}
  spec.description   = %q{Use your Rspec tests to build your API documentation}
  spec.homepage      = "https://github.com/nambrot/rspec-api-blueprint-formatter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files                 = Dir.glob("lib/**/*")
  spec.test_files            = Dir.glob("{test,spec,features}/**/*")
  spec.executables           = Dir.glob("bin/*").map{ |f| File.basename(f) }
  spec.require_paths         = ['lib']

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "rspec", "~> 3.3"
end
