def scan (opts={})
  ClamScan::Client.scan(opts)
end

def scan_eicar
  scan(location: eicar_path)
end

def scan_safe
  scan(location: safe_path)
end
