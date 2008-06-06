require "date"
require "fileutils"
require "rubygems"
require "rake/gempackagetask"
require "spec/rake/spectask"

require "./lib/dejour/version.rb"

dejour_gemspec = Gem::Specification.new do |s|
  s.name             = "dejour"
  s.version          = Dejour::VERSION
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.summary          = "Find awesome stuff"
  s.description      = s.summary
  s.authors          = ["Aaron Patterson"]
  s.email            = "aaronp@rubyforge.org"
  s.homepage         = "http://github.com/aaronp/dejour"
  s.require_path     = "lib"
  s.autorequire      = "dejour"
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.executables      = %w(dejour)
  
  s.add_dependency "dnssd", ">= 0.6.0"
  s.add_dependency "meow"
end

Rake::GemPackageTask.new(dejour_gemspec) do |pkg|
  pkg.gem_spec = dejour_gemspec
end

namespace :gem do
  namespace :spec do
    desc "Update dejour.gemspec"
    task :generate do
      File.open("dejour.gemspec", "w") do |f|
        f.puts(dejour_gemspec.to_ruby)
      end
    end
  end
end

task :install => :package do
  sh %{sudo gem install pkg/dejour-#{Dejour::VERSION}}
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts = ["--options", "spec/spec.opts"]
end

task :default => :spec

desc "Remove all generated artifacts"
task :clean => :clobber_package
