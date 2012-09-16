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
      @data.fetch('format')
    end

    # Return streams
    #
    # @return [Array<Stream>]
    #
    # @api private
    #
    def streams
      @streams ||= @data.fetch('streams',[]).map do |raw|
        stream(raw)
      end
    end

    # Return packets
    #
    # @return [Array<Stream>]
    #
    # @api private
    #
    def packets
      @packets ||= @data.fetch('packets',[]).map do |raw|
        self.class.convert(Packet,raw)
      end
    end

    # Build stream from parsed attributes
    # 
    # @param [Hash] raw
    #
    # @return [Stream]
    #
    # @api private
    #
    def stream(raw)
      index = raw.fetch('index')
      size = 0
      packets.each do |packet|
        next unless packet.stream_index == index
        size+=packet.size
      end

      self.class.convert(Stream,raw.merge('size' => size))
    end

    # Convert raw hash to model attributes 
    #
    # @param [Virtus] model
    # @param [Hash] raw
    #
    # @return [Object]
    #
    # @api private
    #
    def self.convert(model,raw)
      attributes = model.attribute_set.each_with_object({}) do |attribute,attributes|
        name = attribute.name
        attributes[name]=coerce(attribute, raw[name.to_s])
      end

      model.new(attributes)
    end

    # Coerce value to attribute or raise
    #
    # @param [Virtus::Attribute] attribute
    # @param [Object] value
    #
    # @return [Object]
    #
    # @api private
    #
    def self.coerce(attribute,value)
      return if value.nil?

      new_value = attribute.coerce(value)

      unless attribute.value_coerced?(new_value)
        raise "Unable to coerce #{value.inspect} to #{attribute.inspect}"
      end
      new_value
    end
    private_class_method :coerce
  end
end
