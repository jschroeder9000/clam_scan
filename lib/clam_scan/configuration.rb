module ClamScan
  class Configuration
    attr_accessor :default_scan_options
    attr_accessor :client_location
    attr_accessor :raise_unless_safe

    def initialize
      @default_scan_options       = {stdout: true}
      @client_location            = '/usr/bin/clamdscan'
      @raise_unless_safe          = false
    end

    def reset!
      initialize
    end
  end
end
