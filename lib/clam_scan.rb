require "clam_scan/client"
require "clam_scan/configuration"
require "clam_scan/request"
require "clam_scan/response"
require "clam_scan/version"

module ClamScan
  class << self
    attr_accessor :configuration

    def configure
      configuration ||= Configuration.new
      yield configuration if block_given?
    end
  end
end
