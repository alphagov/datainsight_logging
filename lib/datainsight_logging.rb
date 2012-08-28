require "logging"
include Logging.globally

module Datainsight

  module Logging

    def self.configure(env=ENV["RACK_ENV"])
      case (env or "default").to_sym
        when :test
          configure_test
        when :production
          configure_production
        else
          configure_development
      end
    end

    private
    def self.configure_development
      ::Logging.appenders.stdout(:stdout)
      ::Logging.appenders.rolling_file(:file, :filename => 'log/development.log',
                                     :age => 'daily')
      ::Logging.appenders.growl(:growl, :level => :error,
                              :layout => ::Logging::Layouts.pattern(:pattern => '%-5l: %m\n'))

      ::Logging.logger.root.appenders = [:stdout, :file, :growl]
      ::Logging.logger.root.level = :debug
    end

    def self.configure_production
      ::Logging.appenders.rolling_file(:file, :filename => 'log/production.log',
                                     :age => 'daily', :layout => ::Logging::Layouts.json)

      ::Logging.logger.root.appenders = [:file]
      ::Logging.logger.root.level = :info
    end

    def self.configure_test
      ::Logging.appenders.stdout(:stdout)

      ::Logging.logger.root.appenders = [:stdout]
      ::Logging.logger.root.level = :info
    end

    module Helpers
      def logger
        @_logger_ ||= ::Logging::Logger[self]
      end
    end

  end
end