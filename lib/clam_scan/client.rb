module ClamScan
  class Client
    class << self
      def scan (*args)
        response = Request.send(*args)
        # raise if ...
        response
      end
    end
  end
end
