Gem::Specification.new do |s|
  s.name = %q{shadow_facter}
  s.version = "0.0.1"
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bradley Taylor", "Jesse Newland"]
  s.date = %q{2009-01-19}
  s.description = %q{shadow facter}
  s.email = ["jesse@railsmachine.com"]
  #s.default_executable = %q{shadowfacter}
  #s.executables = ["shadowfacter"]
  s.files = [
    "Readme",
    "lib/shadow_facter.rb",
    "lib/shadow_facter/facts.rb",
  ]
  s.has_rdoc = true
  s.homepage = %q{http://railsmachine.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Facter helpers}

  s.add_dependency(%q<facter>, [">= 1.5.2"])
end
