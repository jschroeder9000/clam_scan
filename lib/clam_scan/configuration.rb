module ClamScan
  class Configuration
    attr_accessor :client_location
    attr_accessor :raise_on_error

    def initialize
      @client_location = 'clamscan'
      @raise_on_error  = false
    end
  end
end
