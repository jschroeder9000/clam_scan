module ClamScan
  class Request
    class << self
      def send (location, opts={})
        output_lines = []
        IO::Popen(popen_args(*params)) do |f|
          f.write opts[:stream] if opts[:stream]
          while line = f.gets
            output_lines << line
          end
        end
        output_string = output_lines.join("\n")

        response = Response.new($?, output_string)
        # do some stuff unless response.safe?

        response
      end

    private

      def popen_args (location, opts={})
        # merge opts with some defaults

        args = [::ClamScan.configuration[:client_location]]
        opts.each do |key, value|
          case key
            when :no_summary
              args << '--no-summary' if value
            when :stdout
              args << '--stdout' if value
            when :stream
              # do nothing, but don't raise an error
            else
              # raise some error for unidentified option?
          end
        end
        args << '-' if opts[:stream]

        args
      end
    end
  end
end
