def data_path
  File.expand_path(File.join('..', '..', 'data'), __FILE__)
end

def eicar_path
  File.join(data_path, 'eicar.com')
end

def safe_path
  File.join(data_path, 'foo.txt')
end
