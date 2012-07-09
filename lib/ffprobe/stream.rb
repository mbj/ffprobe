module FFProbe
  # Represent an audio or video stream inside an Container
  class Stream
    include Virtus::ValueObject

    attribute :index,            Integer
    attribute :size,             Integer
    attribute :codec_name,       String
    attribute :codec_long_name,  String
    attribute :codec_type,       String
    attribute :codec_time_base,  Rational
    attribute :codec_tag_string, String
    attribute :codec_tag,        String
    attribute :width,            Integer
    attribute :height,           Integer
    attribute :has_b_frames,     String
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

    # Return byte rate avergage
    #
    # @return [Rational]
    #
    # @api private
    #
    def byte_rate
      Rational(size,duration)
    end

    # Return bite rate avergage
    #
    # @return [Rational]
    #
    # @api private
    #
    def bit_rate
      byterate * 8
    end
  end
end
