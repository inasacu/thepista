require 'builder'

# A LinkSet provisions a bunch of links to sitemap files.  It also writes the index file
# which lists all the sitemap files written.
module SitemapGenerator
  class LinkSet
    @@requires_finalization_opts = [:filename, :sitemaps_path, :sitemaps_namer, :sitemaps_host]
    @@new_location_opts = [:filename, :sitemaps_path, :sitemaps_namer]

    attr_reader :default_host, :sitemaps_path, :filename
    attr_accessor :verbose, :yahoo_app_id, :include_root, :include_index, :sitemaps_host, :adapter, :yield_sitemap

    # Create a new sitemap index and sitemap files.  Pass a block calls to the following
    # methods:
    # * +add+   - Add a link to the current sitemap
    # * +group+ - Start a new group of sitemaps
    #
    # == Options
    #
    # Any option supported by +new+ can be passed.  The options will be
    # set on the instance using the accessor methods.  This is provided mostly
    # as a convenience.
    #
    # In addition to the options to +new+, the following options are supported:
    # * <tt>:finalize</tt> - The sitemaps are written as they get full and at the end
    # of the block.  Pass +false+ as the value to prevent the sitemap or sitemap index
    # from being finalized.  Default is +true+.
    #
    # If you are calling +create+ more than once in your sitemap configuration file,
    # make sure that you set a different +sitemaps_path+ or +filename+ for each call otherwise
    # the sitemaps may be overwritten.
    def create(opts={}, &block)
      reset!
      set_options(opts)
      if verbose
        start_time = Time.now
        puts "In #{sitemap_index.location.public_path}"
      end
      interpreter.eval(:yield_sitemap => yield_sitemap?, &block)
      finalize!
      end_time = Time.now if verbose
      output(sitemap_index.stats_summary(:time_taken => end_time - start_time)) if verbose
      self
    end

    # Dreprecated.  Use create.
    def add_links(&block)
      original_value = @yield_sitemap
      @yield_sitemap = true
      create(&block)
      @yield_sitemap = original_value
    end

    # Constructor
    #
    # == Options:
    # * <tt>:adapter</tt> - instance of a class with a write method which takes a SitemapGenerator::Location
    #   and raw XML data and persists it.  The default adapter is a SitemapGenerator::FileAdapter
    #   which simply writes files to the filesystem.  You can use a SitemapGenerator::WaveAdapter
    #   for uploading sitemaps to remote servers - useful for read-only hosts such as Heroku.  Or
    #   you can provide an instance of your own class to provide custom behavior.
    #
    # * <tt>:default_host</tt> - host including protocol to use in all sitemap links
    #   e.g. http://en.google.ca
    #
    # * <tt>:public_path</tt> - Full or relative path to the directory to write sitemaps into.
    #   Defaults to the <tt>public/</tt> directory in your application root directory or
    #   the current working directory.
    #
    # * <tt>:sitemaps_host</tt> - String.  <b>Host including protocol</b> to use when generating
    #   a link to a sitemap file i.e. the hostname of the server where the sitemaps are hosted.
    #   The value will differ from the hostname in your sitemap links.
    #   For example: `'http://amazon.aws.com/'`.
    #
    #   Note that `include_index` is automatically turned off when the `sitemaps_host` does
    #   not match `default_host`.  Because the link to the sitemap index file that would
    #   otherwise be added would point to a different host than the rest of the links in
    #   the sitemap.  Something that the sitemap rules forbid.
    #
    # * <tt>:sitemaps_path</tt> - path fragment within public to write sitemaps
    #   to e.g. 'en/'.  Sitemaps are written to <tt>public_path</tt> + <tt>sitemaps_path</tt>
    #
    # * <tt>:filename</tt> - symbol giving the base name for files (default <tt>:sitemap</tt>).
    #   The sitemap names are generated like "#{filename}1.xml.gz", "#{filename}2.xml.gz"
    #   and the index name is like "#{filename}_index.xml.gz".
    #
    # * <tt>:sitemaps_namer</tt> - A +SitemapNamer+ instance for generating the sitemap names.
    #
    # * <tt>:include_index</tt> - Boolean.  Whether to <b>add a link to the sitemap index<b>
    #   to the current sitemap.  This points search engines to your Sitemap Index to
    #   include it in the indexing of your site.  Default is `true`.  Turned off when
    #  `sitemaps_host` is set or within a `group()` block.
    #
    # * <tt>:include_root</tt> - Boolean.  Whether to **add the root** url i.e. '/' to the
    #   current sitemap.  Default is `true`.  Turned off within a `group()` block.
    #
    # * <tt>:search_engines</tt> - Hash.  A hash of search engine names mapped to
    #   ping URLs.  See ping_search_engines.
    #
    # * <tt>:verbose</tt> - If +true+, output a summary line for each sitemap and sitemap
    #   index that is created.  Default is +false+.
    def initialize(options={})
      options = SitemapGenerator::Utilities.reverse_merge(options,
        :include_root => true,
        :include_index => true,
        :filename => :sitemap,
        :search_engines => {
          :google         => "http://www.google.com/webmasters/sitemaps/ping?sitemap=%s",
          :ask            => "http://submissions.ask.com/ping?sitemap=%s",
          :bing           => "http://www.bing.com/webmaster/ping.aspx?siteMap=%s",
          :sitemap_writer => "http://www.sitemapwriter.com/notify.php?crawler=all&url=%s"
        }
      )
      options.each_pair { |k, v| instance_variable_set("@#{k}".to_sym, v) }

      # If an index is passed in, protect it from modification.
      # Sitemaps can be added to the index but nothing else can be changed.
      if options[:sitemap_index]
        @protect_index = true
      end
    end

    # Add a link to a Sitemap.  If a new Sitemap is required, one will be created for
    # you.
    #
    # link - string link e.g. '/merchant', '/article/1' or whatever.
    # options - see README.
    #   host - host for the link, defaults to your <tt>default_host</tt>.
    def add(link, options={})
      add_default_links if !@added_default_links
      sitemap.add(link, SitemapGenerator::Utilities.reverse_merge(options, :host => @default_host))
    rescue SitemapGenerator::SitemapFullError
      finalize_sitemap!
      retry
    rescue SitemapGenerator::SitemapFinalizedError
      @sitemap = sitemap.new
      retry
    end

    # Add a link to the Sitemap Index.
    # * link - A string link e.g. '/sitemaps/sitemap1.xml.gz' or a SitemapFile instance.
    # * options - A hash of options including `:lastmod`, ':priority`, ':changefreq` and `:host`
    #
    # The `:host` option defaults to the value of `sitemaps_host` which is the host where your
    # sitemaps reside.  If no `sitemaps_host` is set, the `default_host` is used.
    def add_to_index(link, options={})
      sitemap_index.add(link, SitemapGenerator::Utilities.reverse_merge(options, :host => sitemaps_host))
    end

    # Create a new group of sitemap files.
    #
    # Returns a new LinkSet instance with the options passed in set on it.  All groups
    # share the sitemap index, which is not affected by any of the options passed here.
    #
    # === Options
    # Any of the options to LinkSet.new.  Except for <tt>:public_path</tt> which is shared
    # by all groups.
    #
    # The current options are inherited by the new group of sitemaps.  The only exceptions
    # being <tt>:include_index</tt> and <tt>:include_root</tt> which default to +false+.
    #
    # Pass a block to add links to the new LinkSet.  If you pass a block the sitemaps will
    # be finalized when the block returns.
    #
    # If you are not changing any of the location settings like <tt>filename<tt>,
    # <tt>sitemaps_path</tt>, <tt>sitemaps_host</tt> or <tt>sitemaps_namer</tt>
    # links you add within the group will be added to the current sitemap file (e.g. sitemap1.xml).
    # If one of these options is specified, the current sitemap file is finalized
    # and a new sitemap file started.
    #
    # Options like <tt>:default_host</tt> can be used and it will only affect the links
    # within the group.  Links added outside of the group will revert to the previous
    # +default_host+.
    def group(opts={}, &block)
      @created_group = true
      original_opts = opts.dup

      if (@@requires_finalization_opts & original_opts.keys).empty?
        # If no new filename or path is specified reuse the default sitemap file.
        # A new location object will be set on it for the duration of the group.
        opts[:sitemap] = sitemap
      elsif original_opts.key?(:sitemaps_host) && (@@new_location_opts & original_opts.keys).empty?
        # If no location options are provided we are creating the next sitemap in the
        # current series, so finalize and inherit the namer.
        finalize_sitemap!
        opts[:sitemaps_namer] = sitemaps_namer
      end

      opts = options_for_group(opts)
      @group = SitemapGenerator::LinkSet.new(opts)
      if opts.key?(:sitemap)
        # If the group is sharing the current sitemap, set the
        # new location options on the location object.
        @original_location = @sitemap.location.dup
        @sitemap.location.merge!(@group.sitemap_location)
        if block_given?
          @group.interpreter.eval(:yield_sitemap => @yield_sitemap || SitemapGenerator.yield_sitemap?, &block)
          @sitemap.location.merge!(@original_location)
        end
      elsif block_given?
        @group.interpreter.eval(:yield_sitemap => @yield_sitemap || SitemapGenerator.yield_sitemap?, &block)
        @group.finalize_sitemap!
      end
      @group
    end

    # Ping search engines to notify them of updated sitemaps.
    #
    # Search engines are already notified for you if you run `rake sitemap:refresh`.
    # If you want to ping search engines separately to your sitemap generation, run
    # `rake sitemap:refresh:no_ping` and then run a rake task or script
    # which calls this method as in the example below.
    #
    # == Arguments
    # * sitemap_index_url - The full URL to your sitemap index file.
    #   If not provided the location is based on the `host` you have
    #   set and any other options like your `sitemaps_path`.  The URL
    #   will be CGI escaped for you when included as part of the
    #   search engine ping URL.
    #
    # == Options
    # A hash of one or more search engines to ping in addition to the
    # default search engines.  The key is the name of the search engine
    # as a string or symbol and the value is the full URL to ping with
    # a string interpolation that will be replaced by the CGI escaped sitemap
    # index URL.  If you have any literal percent characters in your URL you
    # need to escape them with `%%`.  For example if your sitemap index URL
    # is `http://example.com/sitemap_index.xml.gz` and your
    # ping url is `http://example.com/100%%/ping?url=%s`
    # then the final URL that is pinged will be `http://example.com/100%/ping?url=http%3A%2F%2Fexample.com%2Fsitemap_index.xml.gz`
    #
    # == Examples
    #
    # Both of these examples will ping the default search engines in addition to `http://superengine.com/ping?url=http%3A%2F%2Fexample.com%2Fsitemap_index.xml.gz`
    #
    #   SitemapGenerator::Sitemap.host('http://example.com/')
    #   SitemapGenerator::Sitemap.ping_search_engines(:super_engine => 'http://superengine.com/ping?url=%s')
    #
    # Is equivalent to:
    #
    #   SitemapGenerator::Sitemap.ping_search_engines('http://example.com/sitemap_index.xml.gz', :super_engine => 'http://superengine.com/ping?url=%s')
    def ping_search_engines(*args)
      require 'cgi/session'
      require 'open-uri'
      require 'timeout'

      engines = args.last.is_a?(Hash) ? args.pop : {}
      index_url = CGI.escape(args.shift || sitemap_index_url)

      output("\n")
      search_engines.merge(engines).each do |engine, link|
        link = link % index_url
        name = Utilities.titleize(engine.to_s)
        begin
          Timeout::timeout(10) {
            open(link)
          }
          output("Successful ping of #{name}")
        rescue Timeout::Error, StandardError => e
          output("Ping failed for #{name}: #{e.inspect} (URL #{link})")
        end
      end
    end

    # Return a count of the total number of links in all sitemaps
    def link_count
      sitemap_index.total_link_count
    end

    # Return the host to use in links to the sitemap files.  This defaults to your
    # +default_host+.
    def sitemaps_host
      @sitemaps_host || @default_host
    end

    # Lazy-initialize a sitemap instance and return it.
    def sitemap
      @sitemap ||= SitemapGenerator::Builder::SitemapFile.new(sitemap_location)
    end

    # Lazy-initialize a sitemap index instance and return it.
    def sitemap_index
      @sitemap_index ||= SitemapGenerator::Builder::SitemapIndexFile.new(sitemap_index_location)
    end

    # Return the full url to the sitemap index file.
    def sitemap_index_url
      sitemap_index.location.url
    end

    def finalize!
      finalize_sitemap!
      finalize_sitemap_index!
    end

    # Return a boolean indicating hether to add a link to the sitemap index file
    # to the current sitemap.  This points search engines to your Sitemap Index so
    # they include it in the indexing of your site, but is not strictly neccessary.
    # Default is `true`.  Turned off when `sitemaps_host` is set or within a `group()` block.
    def include_index?
      if default_host && sitemaps_host && sitemaps_host != default_host
        false
      else
        @include_index
      end
    end

    # Return a boolean indicating whether to automatically add the root url i.e. '/' to the
    # current sitemap.  Default is `true`.  Turned off within a `group()` block.
    def include_root?
      !!@include_root
    end

    # Set verbose on the instance or by setting ENV['VERBOSE'] to true or false.
    # By default verbose is true.  When running rake tasks, pass the <tt>-s</tt>
    # option to rake to turn verbose off.
    def verbose
      if @verbose.nil?
        @verbose = SitemapGenerator.verbose.nil? ? true : SitemapGenerator.verbose
      end
      @verbose
    end

    # Return a boolean indicating whether or not to yield the sitemap.
    def yield_sitemap?
      @yield_sitemap.nil? ? SitemapGenerator.yield_sitemap? : !!@yield_sitemap
    end

    protected

    # Set each option on this instance using accessor methods.  This will affect
    # both the sitemap and the sitemap index.
    #
    # If both `filename` and `sitemaps_namer` are passed, set filename first so it
    # doesn't override the latter.
    def set_options(opts={})
      opts = opts.dup
      %w(filename sitemaps_namer).each do |key|
        if value = opts.delete(key.to_sym)
          send("#{key}=", value)
        end
      end
      opts.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    # Given +opts+, return a hash of options prepped for creating a new group from this LinkSet.
    # If <tt>:public_path</tt> is present in +opts+ it is removed because groups cannot
    # change the public path.
    def options_for_group(opts)
      opts = SitemapGenerator::Utilities.reverse_merge(opts,
        :include_index => false,
        :include_root => false,
        :sitemap_index => sitemap_index
      )
      opts.delete(:public_path)

      # Reverse merge the current settings
      current_settings = [
        :include_root,
        :include_index,
        :sitemaps_path,
        :public_path,
        :sitemaps_host,
        :verbose,
        :default_host,
        :adapter
      ].inject({}) do |hash, key|
        if value = instance_variable_get(:"@#{key}")
          hash[key] = value
        end
        hash
      end
      SitemapGenerator::Utilities.reverse_merge!(opts, current_settings)
      opts
    end

    # Add default links if those options are turned on.  Record the fact that we have done so
    # in an instance variable.
    def add_default_links
      if include_root?
        sitemap.add('/', :lastmod => Time.now, :changefreq => 'always', :priority => 1.0, :host => @default_host)
      end
      if include_index?
        sitemap.add(sitemap_index, :lastmod => Time.now, :changefreq => 'always', :priority => 1.0)
      end
      @added_default_links = true
    end

    # Finalize a sitemap by including it in the index and outputting a summary line.
    # Do nothing if it has already been finalized.
    #
    # Don't finalize if the sitemap is empty and a group has been created.  The reason
    # being that the group will have written out its sitemap.
    #
    # Add the default links if they have not been added yet and no groups have been created.
    # If the default links haven't been added we know that the sitemap is empty,
    # because they are added on the first call to add().  This ensure that if the
    # block passed to create() is empty the default links are still included in the
    # sitemap.
    def finalize_sitemap!
      add_default_links if !@added_default_links && !@created_group
      return if sitemap.finalized? || sitemap.empty? && @created_group
      add_to_index(sitemap)
      output(sitemap.summary)
    end

    # Finalize a sitemap index and output a summary line.  Do nothing if it has already
    # been finalized.
    def finalize_sitemap_index!
      return if @protect_index || sitemap_index.finalized?
      sitemap_index.finalize!
      output(sitemap_index.summary)
    end

    # Return the interpreter linked to this instance.
    def interpreter
      require 'sitemap_generator/interpreter'
      @interpreter ||= SitemapGenerator::Interpreter.new(:link_set => self)
    end

    # Reset this instance.  Keep the same options, but return to the same state
    # as before an sitemaps were created.
    def reset!
      @sitemap_index = nil if @sitemap_index && @sitemap_index.finalized? && !@protect_index
      @sitemap = nil if @sitemap && @sitemap.finalized?
      self.sitemaps_namer.reset # start from 1
      @added_default_links = false
    end

    # Write the given string to STDOUT.  Used so that the sitemap config can be
    # evaluated and some info output to STDOUT in a lazy fasion.
    def output(string)
      return unless verbose
      puts string
    end

    module LocationHelpers
      public

      # Set the host name, including protocol, that will be used by default on each
      # of your sitemap links.  You can pass a different host in your options to `add`
      # if you need to change it on a per-link basis.
      def default_host=(value)
        @default_host = value
        update_location_info(:host, value)
      end

      # Set the public_path.  This path gives the location of your public directory.
      # The default is the public/ directory in your Rails root.  Or if Rails is not
      # found, it defaults to public/ in the current directory (of the process).
      #
      # Example: 'tmp/' if you don't want to generate in public for some reason.
      #
      # Set to nil to use the current directory.
      def public_path=(value)
        @public_path = Pathname.new(value.to_s)
        @public_path = SitemapGenerator.app.root + @public_path if @public_path.relative?
        update_location_info(:public_path, @public_path)
        @public_path
      end

      # Return a Pathname with the full path to the public directory
      def public_path
        @public_path ||= self.send(:public_path=, 'public/')
      end

      # Set the sitemaps_path.  This path gives the location to write sitemaps to
      # relative to your public_path.
      # Example: 'sitemaps/' to generate your sitemaps in 'public/sitemaps/'.
      def sitemaps_path=(value)
        @sitemaps_path = value
        update_location_info(:sitemaps_path, value)
      end

      # Set the host name, including protocol, that will be used on all links to your sitemap
      # files.  Useful when the server that hosts the sitemaps is not on the same host as
      # the links in the sitemap.
      #
      # Note that `include_index` will be turned off to avoid adding a link to a sitemap with
      # a different host than the other links.
      def sitemaps_host=(value)
        @sitemaps_host = value
        update_location_info(:host, value)
      end

      # Set the filename base to use when generating sitemaps and sitemap indexes.
      # The index name will be +value+ with <tt>_index.xml.gz</tt> appended.
      # === Example
      # <tt>filename = :sitemap</tt>
      def filename=(value)
        @filename = value
        self.sitemaps_namer = SitemapGenerator::SitemapNamer.new(@filename)
        self.sitemap_index_namer = SitemapGenerator::SitemapIndexNamer.new("#{@filename}_index")
      end

      # Set the search engines hash to a new hash of search engine names mapped to
      # ping URLs (see ping_search_engines).  If the value is nil it is converted
      # to an empty hash.
      # === Example
      # <tt>search_engines = { :google => "http://www.google.com/webmasters/sitemaps/ping?sitemap=%s" }</tt>
      def search_engines=(value)
        @search_engines = value || {}
      end

      # Return the hash of search engines.
      def search_engines
        @search_engines || {}
      end

      # Set the namer to use when generating SitemapFiles (does not apply to the
      # SitemapIndexFile)
      def sitemaps_namer=(value)
        @sitemaps_namer = value
        @sitemap.location[:namer] = value if @sitemap && !@sitemap.finalized?
      end

      # Return the current sitemaps namer object.  If it not set, looks for it on
      # the current sitemap and if there is no sitemap, creates a new one using
      # the current filename.
      def sitemaps_namer
        @sitemaps_namer ||= @sitemap && @sitemap.location.namer || SitemapGenerator::SitemapNamer.new(@filename)
      end

      # Set the namer to use when generating SitemapFiles (does not apply to the
      # SitemapIndexFile)
      def sitemap_index_namer=(value)
        @sitemap_index_namer = value
        @sitemap_index.location[:namer] = value if @sitemap_index && !@sitemap_index.finalized? && !@protect_index
      end

      def sitemap_index_namer
        @sitemap_index_namer ||= @sitemap_index && @sitemap_index.location.namer || SitemapGenerator::SitemapIndexNamer.new("#{@filename}_index")
      end

      # Return a new +SitemapLocation+ instance with the current options included
      def sitemap_location
        SitemapGenerator::SitemapLocation.new(
          :host => sitemaps_host,
          :namer => sitemaps_namer,
          :public_path => public_path,
          :sitemaps_path => @sitemaps_path,
          :adapter => @adapter
        )
      end

      # Return a new +SitemapIndexLocation+ instance with the current options included
      def sitemap_index_location
        SitemapGenerator::SitemapLocation.new(
          :host => sitemaps_host,
          :namer => sitemap_index_namer,
          :public_path => public_path,
          :sitemaps_path => @sitemaps_path,
          :adapter => @adapter
        )
      end

      protected

      # Update the given attribute on the current sitemap index and sitemap file location objects.
      # But don't create the index or sitemap files yet if they are not already created.
      def update_location_info(attribute, value, opts={})
        opts = SitemapGenerator::Utilities.reverse_merge(opts, :include_index => !@protect_index)
        @sitemap_index.location[attribute] = value if opts[:include_index] && @sitemap_index && !@sitemap_index.finalized?
        @sitemap.location[attribute] = value if @sitemap && !@sitemap.finalized?
      end
    end
    include LocationHelpers
  end
end
