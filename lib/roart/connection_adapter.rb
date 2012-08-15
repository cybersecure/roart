require 'forwardable'

module Roart

  class ConnectionAdapter
    extend Forwardable

    def initialize(config)
      @adapter = Roart::ConnectionAdapters.const_get(config[:adapter].capitalize + "Adapter").new(config)
      if config[:user] && config[:pass]
        @adapter.login(config)
      elsif config[:use_cookie]
        @adapter.set_cookie(config)
      end
    end

    def authenticate(config)
      @adapter.login(config)
    end

    def_delegators :@adapter, :get, :post

  end

end
