require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Myspace < OmniAuth::Strategies::OAuth
      option :name, 'myspace'

      option :client_options, {
        :site               => 'http://api.myspace.com',
        :authorize_path     => '/authorize',
        :access_token_path  => '/access_token',
        :request_token_path => '/request_token',
        :http_method        => 'get',
        :scheme             => :query_string,
      }

      uid { raw_info['id'] }

      info do
        {
          :id           => raw_info['id'],
          :nickname     => raw_info['nickname'],
          :name         => raw_info['displayName'],
          :image        => raw_info['thumbnailUrl'],
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('/v2/people/@me/@self?format=json').body)['entry']
      end
    end
  end
end
