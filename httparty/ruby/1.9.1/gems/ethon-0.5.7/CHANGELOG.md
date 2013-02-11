# Changelog

## Master

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.7...master)

## 0.5.7

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.6...v0.5.7)

Enhancements:

* Use new version of ffi.

## 0.5.6

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.4...v0.5.6)

Bugfixes:

* Easy#reset resets on_complete callbacks.

## 0.5.4

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.3...v0.5.4)

Enhancements:

* Use Libc#getdtablesize to get the FDSet size.
* New libcurl option accept_encoding.
* Documentation updates.

## 0.5.3

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.2...v0.5.3)

Enhancements:

* Deprecate Easy#prepare. It is no longer necessary.
* Unroll metaprogramming for easy and multi options.
* More specs.

Bugfixes:

* Correct size for FDSets
* Add proxytypes to enums.

## 0.5.2

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.1...v0.5.2)

Enhancements:

* New libcurl option keypasswd.

Bugfixes:

* Correct request logging when using multi interface.
* Remove invalid libcurl option sslcertpasswd.

## 0.5.1

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.5.0...v0.5.1)

Bugfixes:

* Mark Curl.select and Curl.easy_perform as blocking so that the GIL is
  released by ffi.

## 0.5.0

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.4.4...v0.5.0)

Enhancements:

* New libcurl option proxyuserpwd
* Rename response_header to response_headers

Bugfixes:

* Mark Curl.select and Curl.easy_perform as blocking so that the GIL is
  released by ffi.

## 0.4.4

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.4.3...v0.4.4)

Enhancements:

* Prepare multi explicit like easy

## 0.4.3

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.4.2...v0.4.3)

Enhancements:

* Remove deprecated libcurl option put
* More documentation
* New libcurl option connecttimeout_ms and timeout_ms
* Support multi options

Bugfixes:

* Handle nil values in query params

## 0.4.2

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.4.1...v0.4.2)

Enhancements:

* New libcurl option forbid_reuse
* Use libcurls escape instead of CGI::escape

## 0.4.1

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.4.0...v0.4.1)

Bugfixes:

* Handle nested hash in an array in params correct
  ( [\#201](https://github.com/typhoeus/typhoeus/issues/201) )

## 0.4.0

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.3.0...v0.4.0)

Enhancements:

* ruby 1.8.7 compatible
* Ethon.logger
* Deal with string param/body
* More documentation

Bugfixes:

* Add multi_cleanup to curl

## 0.3.0

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.2.0...v0.3.0)

Enhancements:

* New libcurl option proxyport
* Raise invalid value error when providing a wrong key for sslversion or httpauth

Bugfixes:

* Libcurl option sslversion is handled correct

## 0.2.0

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.1.0...v0.2.0)

Enhancements:

* GET requests are using custom requests only when there is a request body
* Easy#on_complete takes multiple callbacks
* raise Errors::GlobalInit when libcurls global_init failed instead of
  runtime error
* raise Errors::InvalidOption if option is invalid

## 0.1.0

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.0.2...v0.1.0)

Enhancements:

* Documentation
  ( [Alex P](https://github.com/ifesdjeen), [\#13](https://github.com/typhoeus/ethon/issues/13) )
* New libcurl option dns_cache_timeout
  ( [Chris Heald](https://github.com/cheald), [\#192](https://github.com/typhoeus/typhoeus/pull/192) )

Bugfixes:

* Libcurl option ssl_verifyhost takes an integer.
* Add space between header key and value.

## 0.0.2

[Full Changelog](http://github.com/typhoeus/ethon/compare/v0.0.1...v0.0.2)

Bugfixes:

* Add libcurl.so.4 to ffi_lib in order to load correct lib on Debian.
* Escape zero bytes.

## 0.0.1 Initial version