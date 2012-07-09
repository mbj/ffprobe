require 'open3'
require 'virtus'
require 'rational'
require 'multi_json'

# Library namespace
module FFProbe
  # Error raised when ffprobe exits nonzero
  class InvalidFileError < RuntimeError; end

  COMMAND = %w(
    ffprobe 
      -show_packets
      -show_streams
      -show_format
      -print_format json
  ).freeze

  # Probe stream metrics via ffprobe
  #
  # @param [String] path
  #
  # @return [Format]
  #
  # @example
  #
  #   result = FFProbe.new("/path/to/my/video.mp4")
  #   result # => FFProbe::Format
  #
  # @api public
  #
  def self.probe(path)
    parse(data(path))
  end

  # Return JSON string for path
  #
  # @param [String] path
  #
  # @return [Format]
  #
  # @api private
  #
  def self.data(path)
    command = COMMAND + [path]
    stdout,stderr, status = Open3.capture3(*command)

    unless status.to_i.zero?
      raise InvalidFileError,stderr
    end

    stdout
  end
  private_class_method :data

  # Parse a JSON string into container
  #
  # @param [String] data
  #
  # @return [Container]
  #
  # @api private
  #
  def self.parse(data)
    Parser.new(data).container
  end
  private_class_method :parse
end

require 'ffprobe/stream'
require 'ffprobe/packet'
require 'ffprobe/container'
require 'ffprobe/parser'
