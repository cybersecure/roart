require 'yaml'

module Roart

  module Connections
    RequiredConfig = %w(server adapter)
    RequiredToLogin = %w( user pass )

  end

  class Connection

    attr_reader :agent
    attr_reader :conf

    def initialize(conf)
      puts "Creating Connection"
      if conf.is_a?(String)
        raise RoartError, "Loading Config File not yet implemented"
      elsif conf.class.name == Hash.name #TODO: Figure out why conf.is_a?(Hash) doesn't work
        @conf = conf
      end
      if Roart::check_keys(conf, Roart::Connections::RequiredConfig)
        puts "Required config is present"
        puts @conf.inspect
        @agent = @conf[:login]
        add_methods!
      else
        raise RoartError, "Configuration Error"
      end
    end

    def authenticate(conf)
      if Roart::check_keys(conf, Roart::Connections::RequiredToLogin)
        connection.authenticate(conf)
        self
      end
    end

    def rest_path
      self.server + '/REST/1.0/'
    end

    def get(uri)
      debug "Get Request to RT: #{uri}"
      connection.get(uri)
    end

    def post(uri, payload)
      debug "Post Request to RT: #{uri}"
      connection.post(uri, payload)
    end

    protected

    def connection
      @connection ||= ConnectionAdapter.new(conf)
    end

    def add_methods!
      @conf.each do |key, value|
        (class << self; self; end).send :define_method, key do
          return value
        end
      end
    end

    def debug(args)
      if defined?(Rails)
        Rails.logger.debug args.inspect
      end
    end

  end

end
