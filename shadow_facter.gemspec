Gem::Specification.new do |s|
  s.name = %q{shadow_facter}
  s.version = "0.0.1"
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bradley Taylor"]
  s.date = %q{2009-01-19}
  s.description = %q{Wrapper library for Facter}
  s.email = ["bradley@railsmachine.com"]
  s.default_executable = %q{sfacter}
  s.executables = ["sfacter"]
  s.files = [
    "Readme",
    "lib/shadow_facter.rb",
    "lib/shadow_facter/facts.rb",
    "lib/shadow_facter/facts/kernel_facts.rb",
    "lib/shadow_facter/facts/network_facts.rb",
    "bin/sfacter"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://railsmachine.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Facter wrapper library}

  s.add_dependency(%q<facter>, [">= 1.5.2"])
end
