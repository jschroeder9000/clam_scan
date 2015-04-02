# ClamScan

Ruby wrapper for ClamAV's clamscan/clamdscan.

## Features

* Lightweight pure-ruby wrapper
* System call arguments always properly escaped with `IO.popen`
* Scan a data stream before writing to disk
* Supports and validates all arguments supported by clamscan/clamdscan

## Installation

### Gem

Add this line to your application's Gemfile:

```ruby
gem 'clam_scan'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clam_scan

### ClamAV

You will also need ClamAV (and optionally the ClamAV daemon) installed.  On Ubuntu:

`$ sudo apt-get install clamav` will install ClamAV and the `clamscan` cli client.

`$ sudo apt-get install clamav-daemon` will install the ClamAV daemon and the 'clamdscan' cli client.

Other *nix systems can do the equivalent from their respective package manager or install from source.  Mac users should be able to something equivalent with homebrew.  Windows... good luck.

If you _really_ have an aversion to installing the daemon on your development machine, that's OK, but be aware that using the daemon can be literally thousands of orders of magnitude faster for scanning small files because it doesn't have to load the virus database every time a scan is initiated.  You'll also need to set `client_location` to point to clamscan (see below).

## Usage

### Configuration

```ruby
ClamScan.configure do |config|
  # provide default options to be passed to ClamScan::Client.scan
  # options passed directly to a call to ClamScan::Client.scan will override these
  # by merging the default options with the passed options
  config.default_scan_options       = {stdout: true} # default (request all output to be sent to STDOUT so it can be captured)

  # path to clamscan/clamdscan client
  # try `which clamdscan` or `which clamscan` in your shell to see where you should point this to
  # recommended to set to an absolute path to clamdscan
  config.client_location            = '/usr/bin/clamdscan' # default

  # if set to true, ClamScan will raise an exception
  # unless a scan is successful and no viruses were found
  config.raise_unless_safe          = false # default
end
```

### Example Code

```ruby
# scan file on disk
options = {location: '/path/to/file'}

# scan data stream
options = {stream: some_binary_data}

# initiate scan - returns ClamScan::Response object
respone = ClamScan::Client.scan(options)

# check output from clamscan
puts response.body

# check response status
response.safe?    # true if scan was successful and no virus was found
response.virus?   # true if scan was successful an virus was found
response.error?   # true if scan returned with a known error status
response.unknown? # true if scan returned with an unknown status
response.status   # one of [:error, :safe, :unknown, :virus]

# short snippet appropriate for most situations
unless ClamScan::Client.scan(location: '/path/to/file').safe?
  # do something
end
```

### Advanced Usage

ClamScan supports and validates any options supported by the clamscan cli client.  The convention when passing options to ClamScan is to remove the first two leading hyphens and chang the remaining hyphens to underscores.

```ruby
# equivalent to `clamscan --recursive --max-recursion=5 /path/to/dir`
ClamScan::Client.scan(location: '/path/to/dir', recursive: true, max_recursion: 5)
```

You can also pass an array of custom options that will not be validated.

```ruby
# equivalent to `clamscan --recursive --max-recursion=5 /path/to/dir`
args = ['--recursive', '--max-recursion=5', '/path/to'dir']
ClamScan::Client.scan(custom_args: args)
```

ClamScan _should_ support and validate any arguments supported by ClamAV 0.98.  See `lib/clam_scan/request.rb` and ClamAV's man page.

### Deleting infected files

ClamScan does _not_ delete infected files by default, conforming with the defaults of clamscan/clamdscan.  If you want that behaviour, you can do something like:

```ruby
ClamScan.configure do |config|
  # merge instead of re-assign so as to not blow away {stdout: true} default
  config.default_scan_options.merge {remove: 'yes'}
end
```

Or you could arrange to have them moved or copied somewhere.  See `man clamscan`.

### Exceptions

Any exception raised by ClamScan _should_ be a subclass of `ClamScan::Error`.

If an unrecognized option is passed to `ClamScan::Client::scan` or an error occurs while making attempting to make the system call, a `ClamScan::RequestError` is raised.

If `config.raise_unless_safe` is true, a `ClamScan::VirusDetected`, `ClamScan::UnknownError` or `ClamScan::ResponseError` could be raised.  The first two are subclasses of the last and all have a `response` attribute that contains a `ClamScan::Response` object that can be further inspected.

### Rails

ClamScan is a pure ruby wrapper and thus can be used in any ruby project, including one using rails.

```ruby
# add virus-free validation with carrierwave
validate :virus_free

def virus_free
  if self.file.present? && !ClamScan::Client.scan(location: self.file.url).safe?
    File.delete(self.file.url)
    errors.add(:file, 'That file can not be accepted')
  end
end
```

## Contributing

1. Fork it ( https://github.com/jschroeder9000/clam_scan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
