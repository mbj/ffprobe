require 'spec_helper'

describe FFProbe::Container,'#video_streams' do
  subject { object.video_streams }

  let(:object) { described_class.new(:streams => streams) }

  let(:video_stream) { { :codec_type => 'video' } }
  let(:audio_stream) { { :codec_type => 'audio' } }

  let(:streams) { [video_stream,audio_stream] }

  it 'should return array of video streams' do
    should == [FFProbe::Stream.new(video_stream)]
  end
end
