require 'spec_helper'

describe FFProbe::Stream,'#audio?' do
  subject { object.audio? }

  let(:object) { described_class.new(:codec_type => codec_type) }

  context 'when stream codec_type is "audio"' do
    let(:codec_type) { 'audio' }

    it { should be(true) }
  end

  context 'when stream codec_type is "unknown"' do
    let(:codec_type) { 'unkown' }

    it { should be(false) }
  end
end
