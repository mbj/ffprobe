require 'spec_helper'

describe FFProbe::Container,'#audio_streams' do
  subject { object.audio_streams }

  let(:object) { described_class.new(:streams => streams) }

  let(:video_stream) { { :codec_type => 'video' } }
  let(:audio_stream) { { :codec_type => 'audio' } }

  let(:streams) { [video_stream,audio_stream] }

  it 'should return array of audio streams' do
    should == [FFProbe::Stream.new(audio_stream)]
  end
end
