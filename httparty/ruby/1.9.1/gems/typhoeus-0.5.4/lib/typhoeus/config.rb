module Typhoeus

  # The Typhoeus configuration used to set global
  # options.
  # @example Set the configuration options within a block.
  #   Typhoeus.configure do |config|
  #     config.verbose = true
  #   end
  #
  # @example Set the configuration direct.
  #   Typhoeus::Config.verbose = true
  module Config
    extend self

    # Defines wether the connection is blocked.
    # Defaults to false. When set to true, only
    # stubbed requests are allowed. A
    # {Typhoeus::Errors::NoStub} error is raised,
    # when trying to do a real request. Its possible
    # to work around inside
    # {Typhoeus#with_connection}.
    #
    # @return [ Boolean ]
    #
    # @see Typhoeus::Request::BlockConnection
    # @see Typhoeus::Hydra::BlockConnection
    # @see Typhoeus#with_connection
    # @see Typhoeus::Errors::NoStub
    attr_accessor :block_connection

    # Defines wether GET requests are memoized when using the {Typhoeus::Hydra}.
    #
    # @return [ Boolean ]
    #
    # @see Typhoeus::Hydra
    # @see Typhoeus::Hydra::Memoizable
    attr_accessor :memoize

    # Defines wether curls debug output is shown.
    # Unfortunately it prints to stderr.
    #
    # @return [ Boolean ]
    #
    # @see http://curl.haxx.se/libcurl/c/curl_easy_setopt.html#CURLOPTVERBOSE
    attr_accessor :verbose
  end
end