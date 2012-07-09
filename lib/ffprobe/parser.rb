module FFProbe
  # Parse JSON string into format
  class Parser
    # Return parsed format
    #
    # @return [Container]
    #
    # @api private
    #
    def container
      @container ||= Container.new(format.merge(:streams => streams,:packets => packets))
    end

  private

    # Initialize parser
    #
    # @param [String] data
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(data)
      @data = MultiJson.load(data)
    end

    # Return format hash
    #
    # @return [Hash]
    #
    # @api private
    #
    def format
      @data.fetch('format',{})
    end

    # Return streams
    #
    # @return [Array<Stream>]
    #
    # @api private
    #
    def streams
      @data.fetch('streams',[]).map do |stream|
        self.class.stream(stream)
      end
    end

    # Return packets
    #
    # @return [Array<Stream>]
    #
    # @api private
    #
    def packets
      @data.fetch('packets',[]).map do |packet|
        self.class.packet(packet)
      end
    end

    # Build stream from parsed attributes
    # 
    # @param [Hash] attributes
    #
    # @return [Stream]
    #
    # @api private
    #
    def self.stream(attributes)
      Stream.new(attributes)
    end

    # Build stream from parsed attributes
    # 
    # @param [Hash] attributes
    #
    # @return [Packet]
    #
    # @api private
    #
    def self.packet(attributes)
      Packet.new(attributes)
    end
  end
end
