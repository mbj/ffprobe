require 'spec_helper'

describe FFProbe::Parser,'#container' do
  let(:result) { object.container }

  let(:object) { described_class.new(MultiJson.dump(data)) }

  context 'when successful' do
    let(:data) do
      { 
        'format' => {},
        'packets_and_frames' => [
          {
            'type' => 'packet',
            'size' => 100,
            'stream_index' => 0
          },
          {
            'type' => 'frame',
            'media_type' => 'audio',
          },
          {
            'type' => 'packet',
            'size' => 10,
            'stream_index' => 0
          },
          {
            'type' => 'frame',
            'media_type' => 'video',
          },
          {
            'type' => 'packet',
            'size' => 1,
            'stream_index' => 1
          }
        ],
        'streams' => [
          { 'index' => 0 }
        ],
      }
    end

    context 'streams' do
      subject { result.streams }

      it { should be_a(Array) }
      its(:length) { should be(1) }

      context '[0]' do
        subject { result.streams[0] }

        it { should be_a(FFProbe::Stream) }
        its(:size) { should be(110) }
      end
    end

    context 'packets' do
      subject { result.packets }

      it { should be_a(Array) }

      context '[0]' do
        subject { result.packets[0] }

        it { should be_a(FFProbe::Packet) }
        its(:size) { should be(100) }
      end
    end

    context 'frames' do
      subject { result.frames }

      it { should be_a(Array) }

      context '[0]' do
        subject { result.frames[0] }

        it { should be_a(FFProbe::Frame) }
        its(:media_type) { should eql('audio') }
      end
    end
  end

  context 'with coercion failure' do
    subject { object.container }

    let(:data) do
      { 
        'format' => {},
        'packets_and_frames' => [
          {
            'type' => 'packet',
            'size' => '0x10',
            'stream_index' => 0
          }
        ],
        'streams' => [
          { 'index' => 0 }
        ],
      }
    end

    it 'should raise error' do
      expect { subject }.to raise_error(RuntimeError,'Unable to coerce "0x10" to #<Virtus::Attribute::Integer @name=:size>')
    end
  end
end
