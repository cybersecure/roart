require 'mechanize'

module Roart
  module ConnectionAdapters
    class MechanizeAdapter

      def initialize(config)
        @conf = config
      end

      def login(config)
        @conf.merge!(config)
        agent = RoartMechanize.new
        agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        page = agent.get(@conf[:server])
        form = page.form('login')
        form.user = @conf[:user]
        form.pass = @conf[:pass]
        page = agent.submit form
        @agent = agent
      end

      def set_cookie(config)
        @conf.merge!(config)
        agent = RoartMechanize.new
        agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        cookie = Mechanize::Cookie.new("loginCookieValue", @conf[:cookie])
        cookie.domain = ".cybersecure.com.au"
        cookie.path = "/"
        agent.cookie_jar.add(URI.parse(@conf[:server]), cookie)
        page = agent.get(@conf[:server])
        @agent = agent
      end

      def get(uri)
        @agent.get(uri,[],@conf[:server]).body
      end

      def post(uri, payload)
        @agent.post(uri, payload).body
      end

    end
  end
end
