require 'spec_helper'

describe ClamScan do
  context :error do
    it 'raises ClamScan::RequestError if failure to make system call to client_location' do
      ClamScan.configure do |config|
        config.client_location = '/asdf/zxcv'
      end
        expect{scan_eicar}.to raise_error(ClamScan::RequestError)
    end

    it 'raises ClamScan::RequestError when scanning a non-existant path and raise_unless_safe is true' do
      ClamScan.configure do |config|
        config.raise_unless_safe = true
      end
      expect{scan(location: '/asdf/zxcv')}.to raise_error(ClamScan::ResponseError)
    end

    it 'raises ClamScan::RequestError if an unrecognized option is passed' do
      expect{ClamScan::Client.scan(loaction: eicar_path)}.to raise_error(ClamScan::RequestError)
    end

    it 'raises ClamScan::VirusDetected if virus is detected when raise_unless_safe is true' do
      ClamScan.configure do |config|
        config.raise_unless_safe = true
      end
      expect{scan_eicar}.to raise_error(ClamScan::VirusDetected)
    end

    it 'returns true for error? when scanning a non-existant path' do
      expect(scan(location: '/asdf/zxcv').error?).to be_truthy
    end

    it 'has status of :error when scanning a non-existant path' do
      expect(scan(location: '/asdf/zxcv').status).to eq(:error)
    end
  end

  context :safe do
    before :each do
      @response = scan_safe
    end

    it 'returns false for error?' do
      expect(@response.error?).to be_falsey
    end

    it 'returns true for safe?' do
      expect(@response.safe?).to be_truthy
    end

    it 'returns false for unknown?' do
      expect(@response.unknown?).to be_falsey
    end

    it 'returns false for virus?' do
      expect(@response.virus?).to be_falsey
    end

    it 'has status of :safe' do
      expect(@response.status).to eq(:safe)
    end
  end

  context :streaming do
    it 'detects safety from streamed data' do
      expect(scan(stream: File.read(safe_path)).safe?).to be_truthy
    end

    it 'detects a virus from streamed data' do
      expect(scan(stream: File.read(eicar_path)).virus?).to be_truthy
    end
  end

  context :virus do
    before :each do
      @response = scan_eicar
    end

    it 'returns false for error?' do
      expect(@response.error?).to be_falsey
    end

    it 'returns false for safe?' do
      expect(@response.safe?).to be_falsey
    end

    it 'returns false for unknown?' do
      expect(@response.unknown?).to be_falsey
    end

    it 'returns true for virus?' do
      expect(@response.virus?).to be_truthy
    end

    it 'has status of :virus' do
      expect(@response.status).to eq(:virus)
    end
  end
end
