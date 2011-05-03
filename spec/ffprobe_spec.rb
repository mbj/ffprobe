require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FFProbe" do
  describe 'successful' do
    let(:result) { FFProbe.probe(path) }
    describe 'test.mp4' do
      let(:path) { 'spec/data/test.mp4' }
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

      context 'overridden filename' do
        let(:result) { FFProbe.probe(path,:filename => 'test.m4a') }
        specify { result.guessed_format_name.should == 'm4a' }
      end
    end
  end
end
