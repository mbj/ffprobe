unless Open3.respond_to?(:capture3)
  module FFProbe
    class_eval(<<-RUBY,__FILE__,__LINE__+1)
      class << self
        def capture3(command)
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

        protected :capture3
      end
    RUBY
  end
end
