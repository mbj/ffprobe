require 'spec_helper'

describe FFProbe, '.probe' do
  subject { object.probe(path) }

  let(:object) { FFProbe }
  let(:path)   { '/path' }

  let(:stdout) { mock('stdout') }
  let(:stderr) { 'error' }

  before do
    command = %w(ffprobe -show_frames -show_packets -show_streams -show_format -print_format json /path)
    object.should_receive(:capture3).with(command).and_return([stdout,stderr,status])
  end

  context 'when exitstatus is nonzero' do
    let(:status) { 1 }

    it 'should raise error' do
      expect { subject }.to raise_error(FFProbe::InvalidFileError,stderr)
    end
  end

  context 'when exitstatus is zero' do
    let(:status) { 0 }

    let(:container) { mock('Container') }
    let(:parser) { mock('Parser',:container => container) }

    before do
      FFProbe::Parser.stub(:new => parser)
    end

    it 'should return container' do
      should be(container)
    end

    it 'should instantiate parser with stdout' do
      FFProbe::Parser.should_receive(:new).with(stdout).and_return(parser)
      should be(container)
    end
  end
end
