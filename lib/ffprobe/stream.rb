module FFProbe
  # Represent an audio or video stream inside an Container
  class Stream
    include Virtus::ValueObject

    attribute :index,            Integer
    attribute :codec_name,       String
    attribute :codec_long_name,  String
    attribute :codec_type,       String
    attribute :codec_time_base,  Rational
    attribute :codec_tag_string, String
    attribute :codec_tag,        String
    attribute :width,            Integer
    attribute :height,           Integer
    attribute :has_b_frames,     Integer
    attribute :pix_fmt,          String
    attribute :r_frame_rate,     Rational
    attribute :avg_frame_rate,   Rational
    attribute :time_base,        Rational
    attribute :start_time,       Rational
    attribute :duration,         Rational
    attribute :nb_frames,        Integer
    attribute :tags,             Object
    attribute :sample_rate,      Rational
    attribute :channels,         Integer
    attribute :bits_per_sample,  Integer

    attribute :size,             Integer

    # Return byte rate avergage
    #
    # @return [Rational]
    #
    # @api private
    #
    def byte_rate
      Rational(size,duration)
    end

    # Return bitrate avergage
    #
    # @return [Rational]
    #
    # @api private
    #
    def bit_rate
      byte_rate * 8
    end

    # Check if stream is an audio stream
    #
    # @return [true]
    # @return [false]
    #
    # @api private
    #
    def audio?
      codec_type == 'audio'
    end

    # Check if stream is a video stream
    #
    # @return [true]
    # @return [false]
    #
    # @api private
    #
    def video?
      codec_type == 'video'
    end
  end
end
