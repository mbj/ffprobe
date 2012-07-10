require 'spec_helper'

describe FFProbe::Stream,'#video?' do
  subject { object.video? }

  let(:object) { described_class.new(:codec_type => codec_type) }

  context 'when stream codec_type is "video"' do
    let(:codec_type) { 'video' }

    it { should be(true) }
  end

  context 'when stream codec_type is "unknown"' do
    let(:codec_type) { 'unkown' }

    it { should be(false) }
  end
end
