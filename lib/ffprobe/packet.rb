module FFProbe
  # Represent a packet inside a stream
  class Packet
    include Virtus::ValueObject

    attribute :codec_type,    String
    attribute :stream_index,  Integer
    attribute :pts,           Integer
    attribute :pts_time,      Rational
    attribute :dts,           Integer
    attribute :dts_time,      Rational
    attribute :duration,      Integer
    attribute :duration_time, Rational
    attribute :size,          Integer
    attribute :pos,           Integer
    attribute :flags,         String
  end
end
