module ClamScan
  class Error < StandardError
  end

  class RequestError < Error
  end

  class ResponseError < Error
    attr_reader :response

    def initialize (response, message=nil)
      @response = response
      message ||= response.body
      super(message)
    end
  end

  class UnknownError < ResponseError
    def initialize (response, message=nil)
      message ||= response.body
      message = "An unknown error caused #{::ClamScan.configuration.client_location} to exit with status #{response.process_status.exitstatus.to_s}\n#{message}"
      super(response, message)
    end
  end

  class VirusDetected < ResponseError
  end
end
