require 'json'
require 'net/http'
require_relative 'client/version'

module Korbit
  class Client

    attr :token

    def initialize(options={})
      options.symbolize_keys!
      @api_version = options[:api_version] || 'v1'
      @endpoint = options[:endpoint] || "https://api.korbit.co.kr"
      initialize_token options
    end

    def api_version
      @api_version
    end

    def get(path, params={})
      path = File.join("/#{api_version}", path)
      uri = URI(File.join(@endpoint, path))

      params= @token.attach_token params
      uri.query = params.to_query

      parse Net::HTTP.get_response(uri)
    end

    def post(path, params={})
      path = File.join("/#{api_version}", path)
      uri = URI(File.join(@endpoint, path))
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true if @endpoint.start_with?('https://')
      http.start do |http|
        params = @token.attach_token(params) unless path.end_with?('oauth2/access_token')
        parse http.request_post(path, params.to_query)
      end
    end

    def ticker(currency_pair = 'btc_krw')
      get('ticker', {currency_pair: currency_pair, time: time})
    end

    def detailed_ticker(currency_pair = 'btc_krw')
      get('ticker/detailed', {currency_pair: currency_pair})
    end

    def orderbook(currency_pair = 'btc_krw')
      get('orderbook', {currency_pair: currency_pair})
    end

    def transactions(currency_pair = 'btc_krw', time = 'hour')
      get('transactions', {currency_pair: currency_pair, time: time})
    end

    def constants
      get('constants')
    end

    def buy(currency_pair: 'btc_krw', type: 'limit', price: 500, coin_amount: 1, fiat_amount: 1)
      post('user/orders/buy')
    end

    def sell(currency_pair: 'btc_krw', type: 'limit', price: 500, coin_amount: 1)
      post('user/orders/buy')
    end

    def cancel(currency_pair: 'btc_krw', type: 'limit', price: 500, coin_amount: 1)
      post('user/orders/cancel')
    end

    def open_order(currency_pair: 'btc_krw', offset: 0, limit: 10)
      post('user/orders/open')
    end

    private

    def parse(response)
      JSON.parse response.body
    rescue JSON::ParserError => e
      raise BitBot::UnauthorizedError, response['warning']
    end

    def initialize_token(options)
      if options[:client_id] && options[:client_secret]
        @token = Token.new self, options
        #@token.refresh_token!
      else
        raise ArgumentError, 'Missing key and/or secret'
      end
    end

  end
end
