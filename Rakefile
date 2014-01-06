#!/usr/bin/env rake
require "bundler/gem_tasks"
require "gem_publisher"
require_relative "lib/datainsight_logging"

desc "Publish gem to Rubygems"
task :publish_gem do |t|
  gem = GemPublisher.publish_if_updated("datainsight_logging.gemspec", :rubygems)
  puts "Published #{gem}" if gem
end

namespace :demo do

  task :default => :all

  desc "See log in all modes"
  task :all => [:production, :test, :development]

  [:production, :test, :development]. each { |mode|
    desc "See log in #{mode}"
    task mode do
      puts ">> #{mode.capitalize} Logging"
      Datainsight::Logging.configure(mode)
      logger.trace { "Trace log" }
      logger.debug { "Debug log" }
      logger.info { "Info log" }
      logger.warn { "Warn log" }
      logger.error { "Error log" }
      logger.fatal { "Fatal log" }
    end
  }
end
