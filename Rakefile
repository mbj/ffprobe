require 'rake'

FileList['tasks/**/*.rake'].each { |task| import task }

desc 'Default: run all specs'
task :default => :spec

file 'state-machine.png' => ['grammar/ffprobe.rl'] do
  sh 'ragel grammar/ffprobe.rl -pV | dot -Tpng > state-machine.png'
end

task :graph => 'state-machine.png'
