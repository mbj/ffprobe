module FFProbe
  # Audio / video stream inside a container
  class Frame
    include Virtus::ValueObject

    attribute :media_type,             String
    attribute :key_frame,              Integer
    attribute :pkt_pts,                Integer
    attribute :pkt_pts_time,           Rational
    attribute :pkt_dts,                Integer
    attribute :pkt_dts_time,           Rational
    attribute :pkt_duration,           Integer
    attribute :pkt_duration_time,      Rational
    attribute :pkt_pos,                Integer

    # Audio specific attributes
    attribute :sample_fmt,             String
    attribute :nb_samples,             Integer
    attribute :channels,               Integer
    attribute :channel_layout,         String

    # Video specific attributes
    attribute :width,                  Integer
    attribute :height,                 Integer
    attribute :pix_fmt,                String
    attribute :pict_type,              String
    attribute :coded_picture_number,   Integer
    attribute :display_picture_number, Integer
    attribute :interlaced_frame,       Integer
    attribute :top_field_first,        Integer
    attribute :repeat_pict,            Integer
    attribute :reference,              Integer

    # Check if frame is an audio frame
    #
    # @return [true]
    # @return [false]
    #
    # @api private
    #
    def audio?
      media_type == 'audio'
    end

    # Check if frame is a video frame
    #
    # @return [true]
    # @return [false]
    #
    # @api private
    #
    def video?
      media_type == 'video'
    end
  end
end
