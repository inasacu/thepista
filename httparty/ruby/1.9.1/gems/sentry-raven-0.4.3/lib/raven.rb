require 'raven/version'
require 'raven/backtrace'
require 'raven/configuration'
require 'raven/context'
require 'raven/client'
require 'raven/event'
require 'raven/logger'
require 'raven/rack'
require 'raven/interfaces/message'
require 'raven/interfaces/exception'
require 'raven/interfaces/stack_trace'
require 'raven/interfaces/http'
require 'raven/processors/sanitizedata'

require 'raven/railtie' if defined?(Rails::Railtie)
require 'raven/sidekiq' if defined?(Sidekiq)


module Raven
  class << self
    # The client object is responsible for delivering formatted data to the Sentry server.
    # Must respond to #send. See Raven::Client.
    attr_writer :client

    # A Raven configuration object. Must act like a hash and return sensible
    # values for all Raven configuration options. See Raven::Configuration.
    attr_writer :configuration

    # Additional context for events
    attr_writer :context

    def context
      @context ||= Context.new
    end

    def logger
      @logger ||= Logger.new
    end

    # The configuration object.
    # @see Raven.configure
    def configuration
      @configuration ||= Configuration.new
    end

    # The client object is responsible for delivering formatted data to the Sentry server.
    def client
      @client ||= Client.new(configuration)
    end

    # Tell the log that the client is good to go
    def report_ready
      self.logger.info "Raven #{VERSION} ready to catch errors"
    end

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   Raven.configure do |config|
    #     config.server = 'http://...'
    #   end
    def configure(silent = false)
      if block_given?
        yield(configuration)
      end

      self.client = Client.new(configuration)
      report_ready unless silent
      self.client
    end

    # Send an event to the configured Sentry server
    #
    # @example
    #   evt = Raven::Event.new(:message => "An error")
    #   Raven.send(evt)
    def send(evt)
      client.send(evt)
    end

    # Capture and process any exceptions from the given block, or globally if
    # no block is given
    #
    # @example
    #   Raven.capture do
    #     MyApp.run
    #   end
    def capture(options={}, &block)
      if block
        begin
          block.call
        rescue Error => e
          raise # Don't capture Raven errors
        rescue Exception => e
          capture_exception(e, options)
          raise
        end
      else
        # Install at_exit hook
        at_exit do
          if $!
            logger.debug "Caught a post-mortem exception: #{$!.inspect}"
            capture_exception($!, options)
          end
        end
      end
    end

    def capture_exception(exception, options={})
      evt = Event.capture_exception(exception, options)
      send(evt) if evt
    end

    def capture_message(message, options={})
      evt = Event.capture_message(message, options)
      send(evt) if evt
    end

    def user_context(options={})
      self.context.user.merge!(options)
    end

    def tags_context(options={})
      self.context.tags.merge!(options)
    end

    def extra_context(options={})
      self.context.extra.merge!(options)
    end

    # For cross-language compat
    alias :captureException :capture_exception
    alias :captureMessage :capture_message
  end
end
