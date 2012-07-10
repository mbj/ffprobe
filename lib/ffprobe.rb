require 'open3'
require 'virtus'
require 'rational'
require 'multi_json'
require 'backports'

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
    stdout, stderr, status = capture3(command)

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

  # Capture command output
  #
  # @param [Array] command
  #
  # @return [Array]
  #
  # @api private
  #
  if Open3.respond_to?(:capture3)
    def self.capture3(command)
      Open3.capture3(*command)
    end
  else
    class_eval(<<-RUBY,__FILE__,__LINE__+1)
      def self.capture3(command)
        pi, po, pe = IO.pipe, IO.pipe, IO.pipe

        pid = fork do
          # child
          pi[1].close
          po[0].close
          pe[0].close

          STDIN.reopen(pi[0])
          STDOUT.reopen(po[1])
          STDERR.reopen(pe[1])

          Kernel.exec(*command)
        end

        pi[0].close
        pi[1].close

        po[1].close
        pe[1].close

        stdout, stderr = po[0], pe[0]

        data = Hash.new { |hash,key| hash[key]='' }

        until stdout.eof? and stderr.eof?
          reads = Kernel.select([stdout, stderr]).first || []
          reads.each do |reader|
            data[reader] << reader.read
          end
        end
        
        pid,status = Process.waitpid2(pid)

        [data.fetch(stdout),data.fetch(stderr),status.exitstatus]
      ensure
        [pi,po,pe].flatten.each do |io|
          io.close unless io.closed?
        end
      end
    RUBY
  end

end

require 'ffprobe/stream'
require 'ffprobe/packet'
require 'ffprobe/container'
require 'ffprobe/parser'
