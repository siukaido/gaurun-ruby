require "gaurun-ruby/response"

module Gaurun
  class Client
    def initialize(endpoint: 'http://localhost:1056')
      @endpoint = endpoint_from_env || endpoint
    end

    def push(notification)
      req = generate_push_request(notification)
      do_request(req)
    end

    def parallel_push(notifications)
      hydra = Typhoeus::Hydra.new
      reqs = notifications.map do |notification|
        req = generate_push_request(notification)
        hydra.queue(req)
        req
      end
      hydra.run

      reqs.map do |req|
        Gaurun::Response.new(req.response)
      end
    end

    def config_pushers(max)
      req = generate_request(
        path: "/config/pushers?max=#{max}",
        method: 'put'
      )
      do_request(req)
    end

    def stat_go
      req = generate_request(path: '/stat/go', method: 'get')
      do_request(req)
    end

    def stat_app
      req = generate_request(path: '/stat/app', method: 'get')
      do_request(req)
    end

    private

    def endpoint_from_env
      ENV['GAURUN_ENDPOINT'] || build_endpoint_from_env
    end

    def build_endpoint_from_env
      return unless ENV['GAURUN_PROTOCOL'] && ENV['GAURUN_HOST']

      endpoint = "#{ENV['GAURUN_PROTOCOL']}://#{ENV['GAURUN_HOST']}"
      endpoint += ":#{ENV['GAURUN_PORT']}" if ENV['GAURUN_PORT']
      endpoint
    end

    def generate_request(path:, method:, body: nil)
      path = "/#{path}" unless path[0] == '/'

      Typhoeus::Request.new(
        "#{@endpoint}#{path}",
        method: method.to_sym,
        body: body
      )
    end

    def generate_push_request(notification)
      body = notification.payload.to_json
      generate_request(path: '/push', method: 'post', body: body)
    end

    def do_request(req)
      Gaurun::Response.new(req.run)
    end
  end
end
