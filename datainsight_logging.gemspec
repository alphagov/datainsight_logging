# -*- encoding: utf-8 -*-
require File.expand_path('../lib/datainsight_logging/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = %w(pawel.badenski johannes.thoenes)
  gem.email = %w(pawel.badenski@digital.cabinet-office.gov.uk johannes.thoenes@digital.cabinet-office.gov.uk)
  gem.description   = "Logging configuration for the Data Insight projects."
  gem.summary       = "Logging Configuration"
  gem.homepage      = "https://github.com/alphagov/datainsight_logging"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "datainsight_logging"
  gem.require_paths = %w(lib)
  gem.version = DatainsightLogging::VERSION

  gem.add_dependency('logging')

  gem.add_development_dependency("rake")
  gem.add_development_dependency("gem_publisher", "~> 1.2.0")
  gem.add_development_dependency("gemfury")

end
