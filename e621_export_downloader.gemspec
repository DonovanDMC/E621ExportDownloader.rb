# frozen_string_literal: true

require_relative("lib/e621_export_downloader/version")

Gem::Specification.new do |spec|
  spec.name = "e621_export_downloader"
  spec.version = E621ExportDownloader::Constants::VERSION
  spec.authors = ["Donovan_DMC"]
  spec.email = ["hewwo@yiff.rocks"]

  spec.summary = "A utility for downloading and parsing e621's exports"
  spec.description = spec.summary
  spec.homepage = E621ExportDownloader::Constants::WEBSITE
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.1"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("csv", "~> 3.3")
  spec.add_dependency("faraday", "~> 2.14")
  spec.add_dependency("sorbet-runtime")
  spec.add_dependency("zeitwerk", "~> 2.6")

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
