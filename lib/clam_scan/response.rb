module ClamScan
  class Response
    attr_accessor :output
    attr_accessor :process_status

    def initialize (process_status, output)
      @output = output
      @process_status = process_status
    end

    def body
      @output
    end

    def error?
      status == :error
    end

    def safe?
      status == :safe
    end

    def status
      case @process_status.exitstatus
        when 0
          :safe
        when 1
          :virus
        when 2
          :error
        else
          :unknown
      end
    end

    def unknown?
      status == :unknown
    end

    def virus?
      status == :virus
    end
  end
end
