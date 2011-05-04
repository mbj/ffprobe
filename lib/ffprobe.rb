require 'open3'

module FFProbe
  class Stream
    NAMES = %w(index codec_name codec_long_name codec_type codec_time_base codec_tag_string codec_tag width height has_b_frames pix_fmt r_frame_rate avg_frame_rate time_base start_time duration nb_frames tags sample_rate channels bits_per_sample)
    NAMES.each do |name|
      attr_reader name
    end
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
      NAMES.each do |name|
        instance_variable_set("@#{name}",attributes[name])
      end
    end
  end

  class Result
    NAMES = %w(duration streams size bit_rate tags streams format_names start_time guessed_format_name)
    NAMES.each do |name|
      attr_reader name
    end

    def initialize(format)
      NAMES.each do |name|
        instance_variable_set("@#{name}",format[name])
      end
    end

    def video_streams
      streams.select { |stream| stream.codec_type == 'video' }
    end

    def audio_streams
      streams.select { |stream| stream.codec_type == 'audio' }
    end

    def video_stream
      if(video_streams.length != 1)
        raise "found #{video_streams.length} video_streams, do not knew what to return"
      end
      video_streams.first
    end

    def audio_stream
      if(audio_streams.length != 1)
        raise "found #{audio_streams.length} video_streams, do not knew what to return"
      end
      audio_streams.first
    end
  end

  class << self
    def probe(path,opts={})
      data = status = nil
      Open3.popen3('ffprobe','-show_streams','-show_format',path) do |stdin,stdout,stderr,waiter|
        stdin.close
        data = stdout.read
        status = waiter.value.exitstatus
      end
      return nil unless status.zero?
      make_result(data,opts)
    end

    CONTAINER_START = %r(\A\[([A-Z]+)\]\Z)
    CONTAINER_END = %r(\A\[/([A-Z]+)\]\Z)
    KEY_VALUE = %r(\A([A-Za-z_]+)=(.*)\Z)
    KEY_TAG_VALUE = %r(\ATAG:([A-Za-z_]+)=(.*)\Z)

    def make_result(data,opts={})
      streams = []
      format = nil
      current = {}
      data.each_line do |line|
        if line =~ CONTAINER_START
          current = { 'tags' => {} }
          case $1
          when 'STREAM' then streams << current 
          when 'FORMAT' then format = current
          else 
            return nil # unkown container
          end
        elsif line =~ CONTAINER_END
          current = nil
        elsif line =~ KEY_VALUE
          return nil unless current
          name,value = $1,$2
          value = case name
          when 'duration','bit_rate','start_time','sample_rate' then value.to_f
          when 'channels','index','width','height','nb_frames','bits_per_sample' then value.to_i
          when 'format_name' then
            name = 'format_names'
            value.split ','
          when 'size' then value.to_i
          else value.strip
          end
          raise "#{$1}: #{$2}" unless value

          current[name]=value
        elsif line =~ KEY_TAG_VALUE
          return nil unless current 
          current['tags'][$1]=$2.strip
        end
      end
      return nil unless format
      return nil if streams.empty?
      names = format['format_names'] ||= []
      filename = opts[:filename] || format['filename']
      guessed = if filename 
        ext = File.extname(filename)[1..-1]
        ext if names.include?(ext)
      end
      guessed ||= names.first
      format['guessed_format_name']=guessed
      format['streams']=streams.map { |stream| Stream.new stream }
      Result.new(format)
    end
  end
end
