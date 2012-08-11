module Roart
   class Attachment
      attr_accessor :content
      attr_accessor :id
      attr_accessor :ticket
    
      IntKeys = %w[id]

      def initialize(attrs)
         if attrs.has_key?(:id) and attrs.has_key?(:ticket)
            self.id = attrs[:id]
            self.ticket = attrs[:ticket]
            self.load_content
         end
      end

      def load_content
        uri = self.ticket.class.connection.rest_path + "ticket/#{self.ticket.id}/attachments/#{self.id}"
        page = self.ticket.class.connection.get(uri)
        raise TicketSystemError, "Can't get attachment." unless page
        raise TicketSystemInterfaceError, "Error getting attachment for Ticket: #{self.ticket.id}." unless page.split("\n")[0].include?("200")
        self.content = get_content_from_page(page)
      end

      def get_content_from_page(page)
         page = page.split("\n")
         collect_lines = false
         good_lines = []
         page.each do |line|
            if line.match(/^Content: .*/)
               collect_lines = true
               collections = line.match(/^Content: (.*)/)
               good_lines << collections[1]
               next
            end
            if collect_lines
               collections = line.match(/^\s{9}(.*)/)
               if collections
                  good_lines << collections[1]
               else
                  pp line
               end
            end
         end
         good_lines.join(" ")
#         page.delete_if{|x| !x.include?(":") && !x.match(/^ {9}/) && !x.match(/^ {13}/)}
#         page.each do |ln|
#            if ln.match(/^ {9}/) && !ln.match(/^ {13}/)
#               hash[:content] << "\n" + ln.strip if hash[:content]
#            elsif ln.match(/^ {13}/)
#               ln = ln.split(":")
#               hash[:attachments] << "\n" + ln.first.strip if hash[:attachments]
#            else
#               ln = ln.split(":")
#               unless ln.size == 1 || ln.first == 'Ticket' # we don't want to override the ticket method.
#                  key = ln.delete_at(0).strip.underscore
#                  value = ln.join(":").strip
#                  hash[key] = IntKeys.include?(key) ? value.to_i : value
#               end
#            end
#         end
#         puts hash.inspect
      end
   end
end
