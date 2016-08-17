require 'rake'
require 'rake/clean'
require 'howitzer'
require 'rubocop/rake_task'

load 'howitzer/tasks/framework.rake'
RuboCop::RakeTask.new

if Howitzer.required_clean_logs
  CLEAN.include("#{Howitzer.log_dir}/*")
  Rake::Task[:clean].invoke
end

ENV['RAKE_TASK'] = ARGV[0] if /^features/ === ARGV[0]
Dir['./tasks/**/*.rake'].each { |rake| load rake }
