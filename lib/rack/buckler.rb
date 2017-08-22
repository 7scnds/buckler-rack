require 'net/http'

module Rack
  class Buckler
    DEFAULT_PORT = 3030

    def initialize(app, opts={})
      @app = app
      @opts = {
        port: 3030,
        x_forwarded_for: false,
        read_timeout: 0.1,
        open_timeout: 0.1
      }
      @opts.merge!(opts)
    end

    def reject_request
      [429, {}, ['Too Many Requests']]
    end

    def call(env)
      # Contact the buckler client using the port it is listening on for http requests
      url = URI.parse("http://localhost:#{@port.to_s}/buckler")
      req = Net::HTTP::Get.new(url.to_s)

      headers = Hash[*env.select {|k,v| k.start_with? 'HTTP_'}
        .collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
        .collect {|k,v| [k.split('_').collect(&:capitalize).join('-'), v]}
        .sort
        .flatten]

      headers.each do |k,v|
        req.add_field(k, v)
      end

      # Overwrite the X-Forwarded-For header
      if @opts[:x_forwarded_for]
        req.delete('X-Forwarded-For')
        req.add_field('X-Forwarded-For', env["REMOTE_ADDR"])
      end

      res = nil
      begin
        # Make sure you set a timeout to protect your application latency (this is more of a safety measure).
        res = Net::HTTP.start(url.host, url.port, read_timeout: 0.1, open_timeout: 0.1) {|http|
          http.request(req)
        }
      rescue
        # Do nothing because we want to continue serving requests even though our call to buckler fails
      end

      # If the response from buckler is 429 then the request should be dropped.
      # Here we return status code 429 to the user.
      if res && res.code.to_i == 429
        reject_request
      else
        # Otherwise proceed to process request normally.
        @app.call(env)
      end
    end
  end
end
