Gem::Specification.new do |s|
  s.name = %q{dejour}
  s.version = "1.1.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson"]
  s.autorequire = %q{dejour}
  s.date = %q{2008-06-05}
  s.default_executable = %q{dejour}
  s.description = %q{Find awesome stuff}
  s.email = %q{aaronp@rubyforge.org}
  s.executables = ["dejour"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "bin/dejour", "lib/dejour", "lib/dejour/version.rb", "lib/dejour.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/aaronp/dejour}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Find awesome stuff}

  s.add_dependency(%q<dnssd>, [">= 0.6.0"])
  s.add_dependency(%q<ruby-growl>, [">= 0"])
end
