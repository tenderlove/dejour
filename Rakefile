require "date"
require "fileutils"
require "rubygems"
require "rake/gempackagetask"
require "spec/rake/spectask"

require "./lib/dejour/version.rb"

dejour_gemspec = eval(File.read('dejour.gemspec'))

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
  sh %{sudo gem install --local pkg/dejour-#{Dejour::VERSION}}
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts = ["--options", "spec/spec.opts"]
end

task :default => :spec

desc "Remove all generated artifacts"
task :clean => :clobber_package
