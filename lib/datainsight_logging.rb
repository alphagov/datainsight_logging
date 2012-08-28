require "logging"
include Logging.globally

module Datainsight

  module Logging

    def self.configure(params={})
      env = params[:env] || ENV["RACK_ENV"]
      type = params[:type]
      case (env or "default").to_sym
        when :test
          configure_test
        when :production
          configure_production(type)
        else
          configure_development(type)
      end
    end

    private
    def self.configure_development type
      ::Logging.appenders.stdout(:stdout)
      ::Logging.appenders.rolling_file(:file, :filename => log_file_location(type, :development),
                                     :age => 'daily')
      ::Logging.appenders.growl(:growl, :level => :error,
                              :layout => ::Logging::Layouts.pattern(:pattern => '%-5l: %m\n'))

      ::Logging.logger.root.appenders = [:stdout, :file, :growl]
      ::Logging.logger.root.level = :debug
    end

    def self.configure_production type
      ::Logging.appenders.rolling_file(:file, :filename => log_file_location(type, :production),
                                     :age => 'daily', :layout => ::Logging::Layouts.json)

      ::Logging.logger.root.appenders = [:file]
      ::Logging.logger.root.level = :info
    end

    def self.configure_test
      ::Logging.appenders.stdout(:stdout)

      ::Logging.logger.root.appenders = [:stdout]
      ::Logging.logger.root.level = :info
    end

    def self.log_file_location type, env
      type ? "log/#{type}-#{env}.log" : "log/#{env}.log"
    end

    module Helpers
      def logger
        @_logger_ ||= ::Logging::Logger[self]
      end
    end

  end
end