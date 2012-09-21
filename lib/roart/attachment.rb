module Roart
   class AttachmentCollection < Array
      def to_payload
         hash = Hash.new
         self.each_with_index do |attach, index|
            hash["attachment_#{index+1}"] = attach
         end
         hash
      end
   end

   class Attachment
      attr_accessor :content
      attr_accessor :id
      attr_accessor :ticket
      attr_accessor :content_type
    
      IntKeys = %w[id]

      def initialize(attrs)
         if attrs.has_key?(:id) and attrs.has_key?(:ticket)
            self.id = attrs[:id]
            self.ticket = attrs[:ticket]
            self.load_content_type
         end
      end

      def load_content_type
        uri = self.ticket.class.connection.rest_path + "ticket/#{self.ticket.id}/attachments/#{self.id}"
        page = self.ticket.class.connection.get(uri)
        raise TicketSystemError, "Can't get attachment." unless page
        raise TicketSystemInterfaceError, "Error getting attachment for Ticket: #{self.ticket.id}." unless page.split("\n")[0].include?("200")
        get_content_type_from_page(page)
      end

      def content
        if not @content
          uri = self.ticket.class.connection.rest_path + "ticket/#{self.ticket.id}/attachments/#{self.id}/content"
          page = self.ticket.class.connection.get(uri)
          raise TicketSystemError, "Can't get attachment content." unless page
          if page.blank?
            @content = ""
          else
            raise TicketSystemInterfaceError, "Error getting attachment content for Ticket: #{self.ticket.id}." unless page.split("\n")[0].include?("200")
            @content = get_content_from_page(page)
          end
        end
        @content
      end

      def get_content_type_from_page(page)
         page = page.split("\n")
         page.each do |line|
            if line.match(/^ContentType: (.*)/)
              collections = line.match(/^ContentType: (.*)/)
              self.content_type = collections[1]
              break
            end
         end
      end
      
      def get_content_from_page(page)
         page = page.split("\n")
         2.times { page.shift } #remove the status line and remove the empty line
         page.join("\n")
      end
   end

   class AttachmentFile < File

      attr_reader :name, :file

      def initialize(name, file)
         @name = name
         @file = file
      end

      def path
         name
      end

      def read
         file.read
      end

      def mime_type
         file.content_type if file.respond_to?(:content_type)
      end

      def self.detect(*args)
         AttachmentCollection.new Array(args.compact).flatten.map { |file|
            if file.is_a?(File)
               AttachmentFile.new(File.basename(file.path), file)
            elsif file.is_a?(String)
               AttachmentFile.new(File.basename(file), File.open(file, 'rb'))
            elsif file.respond_to?(:open, :original_filename)
               AttachmentFile.new(file.original_filename, file.open)
            end
         }.compact
      end
   end
end
