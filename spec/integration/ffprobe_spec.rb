require 'spec_helper'

describe FFProbe do
  describe 'successful probe' do
    CACHE = Hash.new do |hash,key|
      hash[key] = FFProbe.probe(key)
    end

    let(:container) { CACHE[path] }

    subject { container }

    describe 'test.mp4' do
      let(:path) { 'spec/data/test.mp4' }

      its(:nb_streams)  { should be(2) }
      its(:format_name) { should == 'mov,mp4,m4a,3gp,3g2,mj2' }
      its(:start_time)  { should be(0.to_r) }
      its(:duration)    { should be('11.114667'.to_r) }
      its(:size)        { should be(1209536) }
      its(:bit_rate)    { should be('870587.000000'.to_r) }

      its(:tags) do
        should == {
          'major_brand' => 'mp42',
          'minor_version' => '0',
          'compatible_brands' => 'mp42isomavc1',
          'creation_time' => '2011-02-28 15:24:43',
          'encoder' => 'HandBrake rev3736 2011010599'
        }
      end

      context 'stream [0]' do
        subject { container.streams[0] }

        its(:tags) do 
          should == {
            'creation_time'=>'2011-02-28 15:24:43', 
            'language'=>'und'
          }
        end

        it {                     should be_a(FFProbe::Stream)                          }
        its(:index)            { should be(0)                                          }
        its(:codec_name)       { should == 'h264'                                      }
        its(:codec_long_name)  { should == 'H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10' }
        its(:codec_type)       { should == 'video'                                     }
        its(:codec_time_base)  { should == '1/180000'                                  }
        its(:codec_tag_string) { should == 'avc1'                                      }
        its(:codec_tag)        { should == '0x31637661'                                }
        its(:width)            { should == 640                                         }
        its(:height)           { should == 360                                         }
        its(:has_b_frames)     { should == 2                                           }
        its(:pix_fmt)          { should == 'yuv420p'                                   }
        its(:r_frame_rate)     { should == Rational(25/1)                              }
        its(:avg_frame_rate)   { should == Rational(12420000,496793)                   }
        its(:time_base)        { should == Rational(1,90000)                           }
        its(:start_time)       { should == Rational(0,1)                               }
        its(:duration)         { should == '11.039844'.to_r                            }
        its(:nb_frames)        { should == 276                                         }
        its(:size)             { should == 1113658                                     }
        its(:bitrate)          { should == Rational('807009.9541261634')               }
      end

#     context 'stream [1]' do
#       subject { container.streams[1] }

#       its(:tags) do
#         should == {
#           'creation_time'=>'2011-02-28 15:24:43',
#           'language'=>'eng'
#         }
#       end

#       it {                     should be_a(FFProbe::Stream                           }
#       its(:index)            { should be(1)                                          }
#       its(:codec_name )      { should == 'aac'                                       }
#       its(:codec_long_name)  { should == 'Advanced Audio Coding'                     }
#       its(:codec_type)       { should == 'audio'                                     }
#       its(:codec_time_base)  { should == Rational(0,1)                               }
#       its(:codec_tag_string) { should == 'mp4a'                                      }
#       its(:codec_tag)        { should == '0x6134706d'                                }
#       its(:sample_rate)      { should == '48000.0'.to_r                              }
#       its(:channels)         { should    be(2)                                       }
#       its(:size)             { should    be(88554)                                   }
#       its(:bits_per_sample)  { should == be(0)                                       }
#       its(:r_frame_rate)     { should == '0.0'.to_r                                  }
#       its(:avg_frame_rate)   { should == '0.0'.to_r                                  }
#       its(:time_base)        { should == Rational(1,48000)                           }
#       its(:start_time)       { should == Rational(0,0)                               }
#       its(:duration)         { should == '11.114667'.to_r                            }
#       its(:nb_frames)        { should    be(521)                                     }
#       its(:bitrate)          { should == '63738.481773677966'.to_r                   }
#     end

#     specify 'allows to calculate video and audio stream sizes' do
#       subject.size.should > container.audio_stream.size + container.video_stream.size
#     end
    end
  end
end
