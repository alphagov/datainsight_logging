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

      logger.debug { "Logging configures" }
    end

    private
    def self.configure_development type
      ::Logging.appenders.stdout(:stdout, :layout => layout_pattern)
      ::Logging.appenders.file(:file, :filename => log_file_location(type, :development),
                               :layout => layout_pattern)
      ::Logging.appenders.growl(:growl, :level => :error,
                                :layout => ::Logging::Layouts.pattern(:pattern => '%-5l: %m\n'))

      ::Logging.logger.root.appenders = [:stdout, :file, :growl]
      ::Logging.logger.root.level = :debug
    end

    def self.configure_production type
      ::Logging.appenders.file(:file, :filename => log_file_location(type, :production),
                               :layout => layout_pattern)

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

    def self.layout_pattern
      ::Logging::Layouts.pattern(:pattern => "%c [%-5l] %d: %m\n")
    end

    module Helpers
      def logger
        @_logger_ ||= ::Logging::Logger[self]
      end
    end

  end
end