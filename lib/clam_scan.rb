require "clam_scan/client"
require "clam_scan/configuration"
require "clam_scan/exceptions"
require "clam_scan/request"
require "clam_scan/response"
require "clam_scan/version"

module ClamScan
  @@configuration = Configuration.new

  def self.configure
    yield @@configuration if block_given?
  end

  def self.configuration
    @@configuration
  end

  configure
end
