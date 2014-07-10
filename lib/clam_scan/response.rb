module ClamScan
  class Response
    attr_accessor :output

    def initialize (status, output)
      @output = output
      @status = status
    end

    def body
      @output
    end

    def error?
      @status.exitstatus == 2
    end

    def safe?
      @status.exitstatus == 0
    end

    def status
      return :error   if error?
      return :safe    if safe?
      return :virus   if virus?
      return :unknown
    end

    def unknown?
      !error? && !safe? && !virus?
    end

    def virus?
      @status.exitstatus == 1
    end
  end
end
