module Geokit
  module Geocoders
    # Provides geocoding based upon an IP address.  The underlying web service is geoplugin.net
    class RipeGeocoder < BaseIpGeocoder
      private

      def self.do_geocode(ip)
        process :json, ip
      end

      def self.submit_url(ip)
        "http://stat.ripe.net/data/geoloc/data.json?resource=#{ip}"
      end

      def self.parse_json(json)
        loc = new_loc
        data = json['data']['locations'][0]

        loc.lat = data['latitude']
        loc.lng = data['longitude']
        set_address_components(data, loc)
        loc.success = (data['status_code'] == 200)
        loc
      end

      def self.set_address_components(data, loc)
        match = data['country'].match /([A-Z]+)(\(([A-Z]+)\))?/
        if match[3]
          loc.state = match[1]
          loc.country_code = match[3]
        else
          loc.country_code = match[1]
        end

        loc.city = data['city']
      end
    end

  end
end
