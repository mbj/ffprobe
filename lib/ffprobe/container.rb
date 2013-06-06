module FFProbe
  # Represent an media container
  class Container
    include Virtus::ValueObject

    attribute :filename,         String
    attribute :nb_streams,       Integer
    attribute :format_name,      String
    attribute :format_long_name, String
    attribute :start_time,       Rational
    attribute :duration,         Rational
    attribute :bit_rate,         Rational
    attribute :size,             Integer
    attribute :tags,             Hash

    attribute :streams,      Array[Stream]
    attribute :packets,      Array[Packet]
    attribute :frames,       Array[Frame]

    # Return video streams
    #
    # @return [Array]
    #
    # @api private
    #
    def video_streams
      streams.select(&:video?)
    end

    # Return video streams
    #
    # @return [Array]
    #
    # @api private
    #
    def audio_streams
      streams.select(&:audio?)
    end
  end
end
