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
      its(:start_time)  { should eql(Rational(0,1)) }
      its(:duration)    { should eql(Rational(11114667,1000000)) }
      its(:size)        { should eql(1209536) }
      its(:bit_rate)    { should eql(Rational(870587,1)) }

      its(:tags) do
        should == {
          'major_brand' => 'mp42',
          'minor_version' => '0',
          'compatible_brands' => 'mp42isomavc1',
          'creation_time' => '2011-02-28 15:24:43',
          'encoder' => 'HandBrake rev3736 2011010599'
        }
      end

      context 'stream[0]' do
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
        its(:codec_time_base)  { should eql(Rational(1,180000))                        }
        its(:codec_tag_string) { should == 'avc1'                                      }
        its(:codec_tag)        { should == '0x31637661'                                }
        its(:width)            { should == 640                                         }
        its(:height)           { should == 360                                         }
        its(:has_b_frames)     { should == 2                                           }
        its(:pix_fmt)          { should == 'yuv420p'                                   }
        its(:r_frame_rate)     { should eql(Rational(25/1))                            }
        its(:avg_frame_rate)   { should eql(Rational(12420000,496793))                 }
        its(:time_base)        { should eql(Rational(1,90000))                         }
        its(:start_time)       { should eql(Rational(0,1))                             }
        its(:duration)         { should eql(Rational(11039844,1000000))                }
        its(:nb_frames)        { should == 276                                         }
        its(:size)             { should == 1113658                                     }
        its(:bit_rate)         { should eql(Rational(2227316000000, 2759961))          }
      end

      context 'stream[1]' do
        subject { container.streams[1] }

        its(:tags) do
          should == {
            'creation_time'=>'2011-02-28 15:24:43',
            'language'=>'eng',
          }
        end

        it {                     should be_a(FFProbe::Stream)                          }
        its(:index)            { should be(1)                                          }
        its(:codec_name )      { should == 'aac'                                       }
        its(:codec_long_name)  { should == 'AAC (Advanced Audio Coding)'               }
        its(:codec_type)       { should == 'audio'                                     }
      # its(:codec_time_base)  { should eql(Rational(0,1))                             }
      # its(:codec_tag_string) { should == 'mp4a'                                      }
      # its(:codec_tag)        { should == '0x6134706d'                                }
      # its(:sample_rate)      { should eql(Rational(48000,1))                         }
      # its(:channels)         { should    be(2)                                       }
      # its(:size)             { should    be(88554)                                   }
      # its(:bits_per_sample)  { should == be(0)                                       }
      # its(:r_frame_rate)     { should eql(Rational(0,0))                             }
      # its(:avg_frame_rate)   { should eql(Rational(0,0))                             }
      # its(:time_base)        { should eql(Rational(1,48000))                         }
      # its(:start_time)       { should eql(Rational(0,0))                             }
      # its(:duration)         { should eql(Rational(11114667,1000000))                }
      # its(:nb_frames)        { should    be(521)                                     }
      # its(:bit_rate)         { should eql(Rational(31869240886838983,500000000000)   }
      end

      specify 'allows to calculate stream sizes' do
        subject.size.should > container.streams.map(&:size).inject(:+)
      end

      context 'frames[0]' do
        subject { container.frames[0] }

        it {                     should be_a(FFProbe::Frame)                           }
        its(:media_type)       { should == 'audio'                                     }
        its(:key_frame)        { should be(1)                                          }
        its(:pkt_pts)          { should == 1024                                        }
        its(:pkt_pts_time)     { should eql(Rational(21333,1000000))                   }
        its(:pkt_dts)          { should == 1024                                        }
        its(:pkt_dts_time)     { should eql(Rational(21333,1000000))                   }
        its(:pkt_duration)     { should == 1024                                        }
        its(:pkt_duration_time){ should eql(Rational(21333,1000000))                   }
        its(:pkt_pos)          { should == 8203                                        }
        its(:sample_fmt)       { should == 's16'                                       }
        its(:nb_samples)       { should == 1024                                        }
        its(:channels)         { should == 2                                           }
        its(:channel_layout)   { should == 'stereo'                                    }
      end

      context 'frames[7]' do
        subject { container.frames[7] }

        it {                           should be_a(FFProbe::Frame)                     }
        its(:media_type)             { should == 'video'                               }
        its(:key_frame)              { should be(1)                                    }
        its(:pkt_pts)                { should == 0                                     }
        its(:pkt_pts_time)           { should eql(Rational(0,1))                       }
        its(:pkt_dts)                { should == 0                                     }
        its(:pkt_dts_time)           { should eql(Rational(0,1))                       }
        its(:pkt_duration)           { should == 3600                                  }
        its(:pkt_duration_time)      { should eql(Rational(1,25))                      }
        its(:pkt_pos)                { should == 7324                                  }
        its(:pix_fmt)                { should == 'yuv420p'                             }
        its(:pict_type)              { should == 'I'                                   }
        its(:coded_picture_number)   { should == 0                                     }
        its(:display_picture_number) { should == 0                                     }
        its(:interlaced_frame)       { should == 0                                     }
        its(:top_field_first)        { should == 0                                     }
        its(:repeat_pict)            { should == 0                                     }
        its(:reference)              { should == 3                                     }
      end
    end
  end
end
