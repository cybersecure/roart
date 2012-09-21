module Roart
  class RoartMechanize < Mechanize
    ##
    # POST to the given +uri+ with the given +query+.  The query is specified by
    # either a string, or a list of key-value pairs represented by a hash or an
    # array of arrays.
    #
    # Examples:
    #   agent.post 'http://example.com/', "foo" => "bar"
    #
    #   agent.post 'http://example.com/', [%w[foo bar]]
    #
    #   agent.post('http://example.com/', "<message>hello</message>",
    #              'Content-Type' => 'application/xml')

    def post(uri, query={}, headers={})
      return request_with_entity(:post, uri, query, headers) if String === query

      node = {}
      # Create a fake form
      class << node
        def search(*args); []; end
      end
      node['method'] = 'POST'
      node['enctype'] = 'application/x-www-form-urlencoded'

      form = Form.new(node)

      query.each { |k, v|
        if v.is_a?(IO)
          form.enctype = 'multipart/form-data'
          ul = Form::FileUpload.new({'name' => k.to_s},::File.basename(v.path))
          ul.file_data = v.read
          ul.mime_type = v.mime_type if v.respond_to?(:mime_type)
          form.file_uploads << ul
        else
          form.fields << Form::Field.new({'name' => k.to_s},v)
        end
      }
      post_form(uri, form, headers)
    end
  end
end
