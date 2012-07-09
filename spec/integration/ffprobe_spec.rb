require 'spec_helper'

describe FFProbe do
  describe 'unsuccessful' do
    let(:result) { FFProbe.probe('/dev/null') }
    specify { result.should be_nil }
  end

  describe 'successful result' do
    let(:result) { FFProbe.probe(path) }

    describe 'test.mp4' do
      let(:path) { 'spec/data/test.mp4' }
      specify { result.should be_kind_of(FFProbe::Result) }
      specify { result.streams.length.should == 2 }
      specify { result.format_names.should == %w(mov mp4 m4a 3gp 3g2 mj2) }
      specify { result.guessed_format_name.should == 'mp4' }
      specify { result.start_time.should == 0.0 }
      specify { result.duration.should == 11.114667 }
      specify { result.size.should == 1209536 }
      specify { result.bit_rate.should == 870587.000000 }
      specify { result.tags.should == {
          'major_brand' => 'mp42',
          'minor_version' => '0',
          'compatible_brands' => 'mp42isomavc1',
          'creation_time' => '2011-02-28 15:24:43',
          'encoder' => 'HandBrake rev3736 2011010599'
        }
      }

      specify 'streams' do
        stream = result.streams[0]
        stream.should be_kind_of(FFProbe::Stream)
        stream.index.should == 0
        stream.codec_name.should == 'h264'
        stream.codec_long_name.should == 'H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10'
        stream.codec_type.should == 'video'
        stream.codec_time_base.should == '1/180000'
        stream.codec_tag_string.should == 'avc1'
        stream.codec_tag.should == '0x31637661'
        stream.width.should == 640
        stream.height.should == 360
        stream.has_b_frames.should == '2'
        stream.pix_fmt.should == 'yuv420p'
        stream.r_frame_rate.should == '25/1'
        stream.avg_frame_rate.should == '12420000/496793'
        stream.time_base.should == '1/90000'
        stream.start_time.should == 0.0
        stream.duration.should ==  11.039844
        stream.nb_frames.should == 276
        stream.size.should == 1113658
        stream.bitrate.should == 807009.9541261634  
        stream.tags.should == {
          'creation_time'=>'2011-02-28 15:24:43', 
          'language'=>'und'
        }

        stream = result.streams[1]
        stream.should be_kind_of(FFProbe::Stream)
        stream.tags.should == {
          'creation_time'=>'2011-02-28 15:24:43',
          'language'=>'eng'
        }
        stream.index.should == 1
        stream.codec_name == 'aac'
        stream.codec_long_name.should == 'Advanced Audio Coding'
        stream.codec_type.should == 'audio'
        stream.codec_time_base.should == '0/1'
        stream.codec_tag_string.should == 'mp4a'
        stream.codec_tag.should == '0x6134706d' 
        stream.sample_rate.should == 48000.0
        stream.channels.should == 2
        stream.size.should == 88554
        stream.bits_per_sample.should == 0
        stream.r_frame_rate.should == '0/0'
        stream.avg_frame_rate.should == '0/0'
        stream.time_base.should == '1/48000' 
        stream.start_time.should == 0.0
        stream.duration.should == 11.114667
        stream.nb_frames.should == 521
        stream.bitrate.should == 63738.481773677966
      end

      specify { result.size.should > result.audio_stream.size + result.video_stream.size }

      describe '#audio_streams' do
        specify { result.audio_streams.should == [result.streams[1]] }
      end

      describe '#video_streams' do
        specify { result.video_streams.should == [result.streams[0]] }
      end

      describe '#video_stream' do
        specify { result.video_stream.should == result.streams[0] }
      end

      describe '#audio_stream' do
        specify { result.audio_stream.should == result.streams[1] }
      end

      context 'overridden filename' do
        let(:result) { FFProbe.probe(path,:filename => 'test.m4a') }
        specify { result.guessed_format_name.should == 'm4a' }
      end
    end
  end
end
